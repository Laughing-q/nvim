#!/usr/bin/env bash
# kimi-code hook: record per-agent status for the Neovim agent manager
# (lua/lq/configs/agents.lua). Called from [[hooks]] entries in
# $KIMI_CODE_HOME/config.toml with the new state as $1, e.g.:
#   command = "~/.config/nvim/scripts/agent-status.sh running"
# The CLI passes a JSON payload on stdin: { "hook_event_name", "session_id", "cwd", ... }.
set -euo pipefail

state="${1:?usage: agent-status.sh <running|idle|interrupted|exited>}"

kimi_home="${KIMI_CODE_HOME:-$HOME/.kimi-code}"
status_dir="$kimi_home/agent-status"
mkdir -p "$status_dir"

payload="$(cat)"
session_id="$(printf '%s' "$payload" | jq -r '.session_id // empty')"
cwd="$(printf '%s' "$payload" | jq -r '.cwd // empty')"

# Agents spawned from Neovim carry KIMI_AGENT_NAME; fall back to the session id.
name="${KIMI_AGENT_NAME:-$session_id}"
name="$(printf '%s' "$name" | sed 's#[/\\]#-#g; s/^[[:space:]]*//; s/[[:space:]]*$//')"
[ -n "$name" ] || exit 0

# Best-effort title: session_index.jsonl maps sessionId -> sessionDir, and
# <sessionDir>/state.json holds the title (read-only; never edit session files).
title=""
if [ -n "$session_id" ] && [ -f "$kimi_home/session_index.jsonl" ]; then
	session_dir="$(jq -r --arg id "$session_id" 'select(.sessionId == $id) | .sessionDir' "$kimi_home/session_index.jsonl" | tail -1)"
	if [ -n "$session_dir" ] && [ -f "$session_dir/state.json" ]; then
		title="$(jq -r '.title // empty' "$session_dir/state.json")"
	fi
fi

tmp_file="$(mktemp "$status_dir/.agent-status.XXXXXX")"
trap 'rm -f "$tmp_file"' EXIT
jq -n \
	--arg name "$name" \
	--arg session_id "$session_id" \
	--arg state "$state" \
	--arg title "$title" \
	--arg cwd "$cwd" \
	--argjson ts "$(date +%s)" \
	'{name: $name, session_id: $session_id, state: $state, title: $title, cwd: $cwd, ts: $ts}' \
	> "$tmp_file"
mv -f "$tmp_file" "$status_dir/$name.json"
