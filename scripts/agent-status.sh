#!/usr/bin/env bash
# Kimi/Codex lifecycle hook: record per-agent status for the Neovim manager
# (lua/lq/configs/agents.lua). The CLI passes a JSON payload on stdin:
# { "hook_event_name", "session_id", "cwd", ... }.
#
# New form: agent-status.sh <kimi|codex> <running|idle|interrupted|exited>
# The legacy Kimi form, agent-status.sh <state>, remains supported.
set -euo pipefail

case "${1:-}" in
kimi | codex)
	provider="$1"
	state="${2:?usage: agent-status.sh <kimi|codex> <running|idle|interrupted|exited>}"
	;;
running | idle | interrupted | exited)
	provider="kimi"
	state="$1"
	;;
*)
	echo "usage: agent-status.sh <kimi|codex> <running|idle|interrupted|exited>" >&2
	exit 2
	;;
esac

case "$provider" in
kimi)
	agent_home="${KIMI_CODE_HOME:-$HOME/.kimi-code}"
	name="${KIMI_AGENT_NAME:-}"
	;;
codex)
	agent_home="${CODEX_HOME:-$HOME/.codex}"
	# Codex hooks do not inherit a terminal-specific agent name. Its session id
	# is both the hook status file name and the manager's durable identity.
	name=""
	;;
esac
status_dir="$agent_home/agent-status"
mkdir -p "$status_dir"

payload="$(cat)"
session_id="$(printf '%s' "$payload" | jq -r '.session_id // empty')"
cwd="$(printf '%s' "$payload" | jq -r '.cwd // empty')"

# Kimi hooks inherit their managed name; Codex and outside sessions use the id.
name="${name:-$session_id}"
name="$(printf '%s' "$name" | sed 's#[/\\]#-#g; s/^[[:space:]]*//; s/[[:space:]]*$//')"
[ -n "$name" ] || exit 0

# Best-effort title: session_index.jsonl maps sessionId -> sessionDir, and
# <sessionDir>/state.json holds the title (read-only; never edit session files).
title=""
if [ "$provider" = "kimi" ] && [ -n "$session_id" ] && [ -f "$agent_home/session_index.jsonl" ]; then
	session_dir="$(jq -r --arg id "$session_id" 'select(.sessionId == $id) | .sessionDir' "$agent_home/session_index.jsonl" | tail -1)"
	if [ -n "$session_dir" ] && [ -f "$session_dir/state.json" ]; then
		title="$(jq -r '.title // empty' "$session_dir/state.json")"
	fi
fi

tmp_file="$(mktemp "$status_dir/.agent-status.XXXXXX")"
trap 'rm -f "$tmp_file"' EXIT
jq -n \
	--arg provider "$provider" \
	--arg name "$name" \
	--arg session_id "$session_id" \
	--arg state "$state" \
	--arg title "$title" \
	--arg cwd "$cwd" \
	--argjson ts "$(date +%s)" \
	'{provider: $provider, name: $name, session_id: $session_id, state: $state, title: $title, cwd: $cwd, ts: $ts}' \
	>"$tmp_file"
mv -f "$tmp_file" "$status_dir/$name.json"
