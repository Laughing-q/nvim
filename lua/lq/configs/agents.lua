-- Multi-agent manager for kimi-code CLI sessions running in toggleterm floats.
--
-- Each agent is a named toggleterm Terminal (float). Status (running / idle /
-- interrupted / exited) comes from kimi-code hooks (see scripts/agent-status.sh),
-- which write $KIMI_CODE_HOME/agent-status/<name>.json; a timer polls that
-- directory and refreshes the sidebar and the heirline component.
-- Exited agents stay in the registry (so their float can still be toggled)
-- but are hidden from the sidebar, picker and statusline.
--
-- Persistence: live agents (with a known session id) are saved per project
-- to $KIMI_CODE_HOME/agent-registry/<hash>.json on spawn/kill/exit and
-- VimLeavePre, and restored on setup. Restored agents have no terminal yet;
-- it is spawned lazily on first toggle via `kimi --session <id>`.
--
-- UI notes: all colors come from semantic highlight links (Diagnostic* for
-- states, Title/Comment/CursorLine for chrome) so the sidebar follows the
-- active colorscheme; groups are namespaced KimiAgents* and re-applied on
-- ColorScheme.

local M = {}

---@class KimiAgent
---@field name string
---@field term table|nil toggleterm Terminal (nil until first toggle for restored agents)
---@field cmd string|nil terminal command (nil means plain "kimi")
---@field state "running"|"idle"|"interrupted"|"exited"
---@field title string
---@field session_id string|nil
---@field spawned_at integer|nil os.time() at terminal creation, used to ignore stale status files
---@field root string|nil project root at spawn, used to ignore status from other projects
---@field _want_title boolean|nil pending /title send (fresh and restored agents)

---@type KimiAgent[]
M.agents = {}

local KIMI_HOME = vim.env.KIMI_CODE_HOME or (vim.fn.expand("~/.kimi-code"))
local STATUS_DIR = KIMI_HOME .. "/agent-status"
local INDEX_FILE = KIMI_HOME .. "/session_index.jsonl"
local REGISTRY_DIR = KIMI_HOME .. "/agent-registry"

local NS_STATE = vim.api.nvim_create_namespace("kimi_agents_state")
local NS_CURSOR = vim.api.nvim_create_namespace("kimi_agents_cursor")

local STATE_ICON = {
	running = "●",
	idle = "●",
	interrupted = "◐",
	exited = "✕",
}
local STATE_HL = {
	running = "DiagnosticWarn",
	idle = "DiagnosticOk",
	interrupted = "DiagnosticWarn",
	exited = "DiagnosticError",
}

---Namespaced, colorscheme-following highlight groups (default = user can override).
local function set_hls()
	local hls = {
		KimiAgentsCurrent = { link = "CursorLine" }, -- agent block under the cursor
		KimiAgentsHeader = { link = "Title" }, -- sidebar header line
		KimiAgentsName = { bold = true }, -- agent name in its header line
		KimiAgentsMuted = { link = "Comment" }, -- state tag, session title, preview
	}
	for group, def in pairs(hls) do
		def.default = true
		vim.api.nvim_set_hl(0, group, def)
	end
	-- hide the ~ column below the last sidebar line (fg = theme Normal bg)
	local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
	if normal.bg then
		vim.api.nvim_set_hl(0, "KimiAgentsEndOfBuffer", { fg = normal.bg, default = true })
	end
end
set_hls()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hls })

M._last = nil ---@type string|nil
M._next_count = 101
M._timer = nil
M._dead_sessions = {} ---@type table<string, boolean> session ids killed here; their hook writes are ignored
M._sidebar = { buf = nil, win = nil, line_map = {}, block_map = {} }

local function notify(msg, level)
	vim.notify(msg, level or vim.log.levels.INFO, { title = "kimi agents" })
end

local function sanitize(name)
	return (name:gsub("[/\\]", "-"):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function project_root()
	return vim.fs.root(0, ".git") or vim.fn.getcwd()
end

local function find(name)
	for i, a in ipairs(M.agents) do
		if a.name == name then
			return a, i
		end
	end
	return nil, nil
end

local function find_by_session(session_id)
	for _, a in ipairs(M.agents) do
		if a.session_id == session_id then
			return a
		end
	end
	return nil
end

---Agents that are still alive (exited ones are hidden from all UI).
---@return KimiAgent[]
local function visible_agents()
	local out = {}
	for _, a in ipairs(M.agents) do
		if a.state ~= "exited" then
			table.insert(out, a)
		end
	end
	return out
end

local function next_count()
	local n = M._next_count
	M._next_count = M._next_count + 1
	return n
end

local function refresh()
	vim.cmd("redrawstatus")
	M._render_sidebar()
end

-- ---------------------------------------------------------------- polling --
--
-- Known limitation (accepted in review): killing an agent within ~2s of
-- spawning — before its session_id is known — leaves no tombstone, so a late
-- hook write from it can briefly leak state into an immediate same-named
-- respawn. Self-heals on the next hook event; recover by killing/respawning.

local function poll()
	if #M.agents == 0 then
		return
	end
	local changed = false
	for _, entry in ipairs(vim.fn.glob(STATUS_DIR .. "/*.json", false, true)) do
		local ok, lines = pcall(vim.fn.readfile, entry)
		if ok and lines[1] then
			local ok2, status = pcall(vim.json.decode, table.concat(lines, "\n"))
			if ok2 and type(status) == "table" then
				-- tombstoned sessions (killed here) must never update anything:
				-- a killed agent's late hook writes can otherwise leak into a
				-- same-named respawn whose session_id isn't known yet
				if status.session_id and M._dead_sessions[status.session_id] then
					goto continue
				end
				local agent = (status.name and find(status.name))
					or (status.session_id and find_by_session(status.session_id))
				-- ignore status written no later than this agent's spawn (stale
				-- file from a previous life under the same name/session)
				if agent and status.ts and agent.spawned_at and status.ts <= agent.spawned_at then
					agent = nil
				end
				-- ignore status from a different session or a different project
				-- (the status dir is shared across all nvim instances)
				if
					agent
					and agent.session_id
					and status.session_id
					and status.session_id ~= ""
					and status.session_id ~= agent.session_id
				then
					agent = nil
				end
				if agent and agent.root and status.cwd and status.cwd ~= "" and status.cwd ~= agent.root then
					agent = nil
				end
				if agent then
					-- a restored agent without a terminal yet must not be
					-- hidden by a stale "exited" (fired when the previous nvim
					-- killed the session): it stays resumable in the sidebar
					local new_state = status.state
					if new_state == "exited" and not agent.term then
						new_state = nil
					end
					if new_state and agent.state ~= new_state then
						agent.state = new_state
						changed = true
					end
					if status.session_id and status.session_id ~= "" and not agent.session_id then
						agent.session_id = status.session_id
						changed = true
					end
					if status.title and status.title ~= "" then
						-- titles come from lastPrompt and may contain newlines,
						-- which nvim_buf_set_lines would reject
						local title = status.title:gsub("\n", " ")
						if agent.title ~= title then
							agent.title = title
							changed = true
						end
					end
					-- name the kimi session itself. Sessions are created lazily
					-- on the first prompt and /title only works while the agent
					-- is idle, so this must wait for the first turn to end.
					if
						agent._want_title
						and agent.session_id
						and agent.state ~= "running"
						and agent.term
						and agent.term.job_id
					then
						agent._want_title = false
						-- raw chansend: term:send would steal window focus. Text
						-- and Enter must go in separate chunks — in one chunk the
						-- TUI drops the Enter (verified experimentally).
						vim.api.nvim_chan_send(agent.term.job_id, "/title " .. agent.name)
						vim.defer_fn(function()
							if agent.term and agent.term.job_id then
								vim.api.nvim_chan_send(agent.term.job_id, "\r")
							end
						end, 300)
					end
				end
			end
		end
		::continue::
	end
	if changed then
		refresh()
	end
end

-- exposed for the headless test suite
M._poll = poll

local function start_timer()
	if M._timer then
		return
	end
	M._timer = vim.uv.new_timer()
	M._timer:start(
		1000,
		2000,
		vim.schedule_wrap(function()
			-- stop once nothing alive remains (exited agents stay in the
			-- registry but need no polling); spawn() restarts the timer
			if #visible_agents() == 0 then
				M._timer:stop()
				M._timer:close()
				M._timer = nil
				return
			end
			pcall(poll)
		end)
	)
end

-- ------------------------------------------------------------ persistence --

local function registry_path(root)
	return REGISTRY_DIR .. "/" .. vim.fn.sha256(root):sub(1, 16) .. ".json"
end

---Persist this project's live agents so they reappear on the next nvim
---start. Agents without a known session id are skipped: kimi creates
---sessions lazily on the first prompt, so an agent that never got one has
---no session to resume.
function M.save_registry()
	local root = project_root()
	local out = {}
	for _, a in ipairs(M.agents) do
		if a.state ~= "exited" and a.session_id and a.root == root then
			table.insert(out, { name = a.name, session_id = a.session_id, title = a.title })
		end
	end
	local path = registry_path(root)
	if #out == 0 then
		vim.fn.delete(path)
		return
	end
	vim.fn.mkdir(REGISTRY_DIR, "p")
	local f = io.open(path, "w")
	if not f then
		return
	end
	f:write(vim.json.encode({ agents = out }))
	f:close()
end

---Re-register agents saved by a previous nvim session of this project.
---No terminals are spawned here; each agent resumes lazily on first toggle.
function M.restore_registry()
	local root = project_root()
	local f = io.open(registry_path(root), "r")
	if not f then
		return
	end
	local ok, data = pcall(vim.json.decode, f:read("*a"))
	f:close()
	if not ok or type(data) ~= "table" or type(data.agents) ~= "table" then
		return
	end
	local restored = 0
	for _, e in ipairs(data.agents) do
		if e.name and e.session_id and not find(e.name) then
			table.insert(M.agents, {
				name = e.name,
				term = nil,
				cmd = "kimi --session " .. vim.fn.shellescape(e.session_id),
				state = "idle",
				title = e.title or "",
				session_id = e.session_id,
				spawned_at = nil,
				root = root,
				-- also name sessions restored from before /title existed
				_want_title = true,
			})
			restored = restored + 1
		end
	end
	if restored > 0 then
		M._last = M.agents[#M.agents].name
		start_timer()
		M.sidebar_toggle()
		-- keep focus on the file, the sidebar is just there for visibility
		vim.cmd("wincmd p")
		refresh()
		notify(restored .. " agent(s) restored — <CR> in the sidebar to resume")
	end
end

-- ---------------------------------------------------------------- sidebar --

local SIDEBAR_WIDTH = 42
local PREVIEW_LINES = 2

local function preview_lines(agent)
	local term = agent.term
	if not term or not term.bufnr or not vim.api.nvim_buf_is_valid(term.bufnr) then
		return {}
	end
	local lines = vim.api.nvim_buf_get_lines(term.bufnr, -60, -1, false)
	local out = {}
	for i = #lines, 1, -1 do
		local s = vim.trim(lines[i])
		if s ~= "" then
			table.insert(out, 1, s)
		end
		if #out >= PREVIEW_LINES then
			break
		end
	end
	return out
end

---Highlight the whole block of the agent under the cursor.
local function sidebar_highlight_current()
	local sb = M._sidebar
	if not sb.buf or not vim.api.nvim_buf_is_valid(sb.buf) then
		return
	end
	vim.api.nvim_buf_clear_namespace(sb.buf, NS_CURSOR, 0, -1)
	if not sb.win or not vim.api.nvim_win_is_valid(sb.win) then
		return
	end
	local cur = vim.api.nvim_win_get_cursor(sb.win)[1]
	for _, b in ipairs(sb.block_map) do
		if cur >= b.first and cur <= b.last then
			for l = b.first - 1, b.last - 1 do
				vim.api.nvim_buf_add_highlight(sb.buf, NS_CURSOR, "KimiAgentsCurrent", l, 0, -1)
			end
			return
		end
	end
end

function M._render_sidebar()
	local sb = M._sidebar
	if not sb.buf or not vim.api.nvim_buf_is_valid(sb.buf) then
		return
	end
	local agents = visible_agents()
	local lines = { "Kimi Agents (" .. #agents .. ")", "" }
	-- highlight segments: { line (0-based), hl_group, col_start, col_end }
	local segs = { { 0, "KimiAgentsHeader", 0, -1 } }
	sb.line_map = {}
	sb.block_map = {}
	if #agents == 0 then
		table.insert(segs, { #lines, "KimiAgentsMuted", 0, -1 })
		table.insert(lines, "  no agents — n to spawn")
	end
	for _, a in ipairs(agents) do
		local icon = STATE_ICON[a.state] or "?"
		local header = string.format("%s %s [%s]", icon, a.name, a.state)
		local first = #lines + 1
		sb.line_map[first] = a.name
		table.insert(lines, header)
		local line0 = #lines - 1
		table.insert(segs, { line0, STATE_HL[a.state] or "Comment", 0, #icon })
		table.insert(segs, { line0, "KimiAgentsName", #icon + 1, #icon + 1 + #a.name })
		table.insert(segs, { line0, "KimiAgentsMuted", #icon + 1 + #a.name, -1 })
		if a.title ~= "" then
			table.insert(segs, { #lines, "KimiAgentsMuted", 0, -1 })
			table.insert(lines, "  " .. a.title)
		end
		if not a.term then
			table.insert(segs, { #lines, "KimiAgentsMuted", 0, -1 })
			table.insert(lines, "  <CR> to resume session")
		end
		for _, p in ipairs(preview_lines(a)) do
			table.insert(segs, { #lines, "KimiAgentsMuted", 0, -1 })
			table.insert(lines, "  " .. vim.fn.strcharpart(p, 0, SIDEBAR_WIDTH - 4))
		end
		table.insert(sb.block_map, { first = first, last = #lines })
		table.insert(lines, "")
	end
	vim.bo[sb.buf].modifiable = true
	vim.api.nvim_buf_set_lines(sb.buf, 0, -1, false, lines)
	vim.api.nvim_buf_clear_namespace(sb.buf, NS_STATE, 0, -1)
	for _, s in ipairs(segs) do
		vim.api.nvim_buf_add_highlight(sb.buf, NS_STATE, s[2], s[1], s[3], s[4])
	end
	vim.bo[sb.buf].modifiable = false
	sidebar_highlight_current()
end

local function sidebar_agent_at_cursor()
	local sb = M._sidebar
	local line = vim.api.nvim_win_get_cursor(0)[1]
	-- nearest mapped header line at or above the cursor
	for l = line, 1, -1 do
		if sb.line_map[l] then
			return sb.line_map[l]
		end
	end
	return nil
end

---Move the cursor to the previous/next agent header (wraps around).
---@param direction integer -1 for up, 1 for down
local function sidebar_jump(direction)
	local sb = M._sidebar
	local headers = {}
	for l in pairs(sb.line_map) do
		table.insert(headers, l)
	end
	if #headers == 0 then
		return
	end
	table.sort(headers)
	local cur = vim.api.nvim_win_get_cursor(0)[1]
	local target = direction < 0 and headers[#headers] or headers[1]
	for _, l in ipairs(headers) do
		if direction < 0 and l < cur then
			target = l
		elseif direction > 0 and l > cur then
			target = l
			break
		end
	end
	vim.api.nvim_win_set_cursor(0, { target, 0 })
	sidebar_highlight_current()
end

local function sidebar_close()
	local sb = M._sidebar
	if sb.win and vim.api.nvim_win_is_valid(sb.win) then
		vim.api.nvim_win_close(sb.win, true)
	end
	sb.win = nil
end

function M.sidebar_toggle()
	local sb = M._sidebar
	if sb.win and vim.api.nvim_win_is_valid(sb.win) then
		sidebar_close()
		return
	end
	if not sb.buf or not vim.api.nvim_buf_is_valid(sb.buf) then
		sb.buf = vim.api.nvim_create_buf(false, true)
		vim.bo[sb.buf].buftype = "nofile"
		vim.bo[sb.buf].bufhidden = "hide"
		vim.bo[sb.buf].swapfile = false
		vim.bo[sb.buf].filetype = "kimiagents"
		local opts = { buffer = sb.buf, silent = true, nowait = true }
		vim.keymap.set("n", "<CR>", function()
			local name = sidebar_agent_at_cursor()
			if name then
				M.toggle(name)
			end
		end, vim.tbl_extend("force", opts, { desc = "toggle agent float" }))
		local kill_at_cursor = function()
			local name = sidebar_agent_at_cursor()
			if name then
				M.kill(name)
			end
		end
		vim.keymap.set("n", "d", kill_at_cursor, vim.tbl_extend("force", opts, { desc = "kill agent" }))
		vim.keymap.set("n", "x", kill_at_cursor, vim.tbl_extend("force", opts, { desc = "kill agent" }))
		vim.keymap.set("n", "n", function()
			M.spawn()
		end, vim.tbl_extend("force", opts, { desc = "new agent" }))
		vim.keymap.set("n", "r", function()
			M.resume()
		end, vim.tbl_extend("force", opts, { desc = "resume kimi session" }))
		vim.keymap.set("n", "q", sidebar_close, vim.tbl_extend("force", opts, { desc = "close sidebar" }))
		-- jump between agents with one up/down (this config maps i=up, k=down)
		vim.keymap.set("n", "i", function()
			sidebar_jump(-1)
		end, vim.tbl_extend("force", opts, { desc = "previous agent" }))
		vim.keymap.set("n", "k", function()
			sidebar_jump(1)
		end, vim.tbl_extend("force", opts, { desc = "next agent" }))
		vim.api.nvim_create_autocmd("CursorMoved", {
			buffer = sb.buf,
			callback = sidebar_highlight_current,
		})
		-- selection highlight only while the sidebar has focus
		vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
			buffer = sb.buf,
			callback = function()
				if vim.api.nvim_buf_is_valid(sb.buf) then
					vim.api.nvim_buf_clear_namespace(sb.buf, NS_CURSOR, 0, -1)
				end
			end,
		})
		vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
			buffer = sb.buf,
			callback = sidebar_highlight_current,
		})
	end
	vim.cmd("botright " .. SIDEBAR_WIDTH .. "vsplit")
	sb.win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(sb.win, sb.buf)
	vim.wo[sb.win].winfixwidth = true
	vim.wo[sb.win].number = false
	vim.wo[sb.win].relativenumber = false
	vim.wo[sb.win].signcolumn = "no"
	vim.wo[sb.win].wrap = false
	vim.wo[sb.win].list = false
	vim.wo[sb.win].spell = false
	vim.wo[sb.win].winhl = "EndOfBuffer:KimiAgentsEndOfBuffer"
	M._render_sidebar()
end

-- -------------------------------------------------------------- lifecycle --

---Create the toggleterm terminal for an agent — at spawn time, or lazily on
---first toggle for agents restored from the registry.
local function make_terminal(agent)
	local Terminal = require("toggleterm.terminal").Terminal
	agent.spawned_at = os.time()
	agent.term = Terminal:new({
		cmd = agent.cmd or "kimi",
		direction = "float",
		count = next_count(),
		display_name = agent.name,
		dir = agent.root or project_root(),
		env = { KIMI_AGENT_NAME = agent.name },
		on_exit = function()
			agent.state = "exited"
			refresh()
			M.save_registry()
		end,
	})
	return agent.term
end

---@param name string|nil prompt when nil
---@param cmd string|nil defaults to "kimi"
function M.spawn(name, cmd)
	if not name then
		vim.ui.input({ prompt = "Agent name: " }, function(input)
			if input and vim.trim(input) ~= "" then
				M.spawn(input, cmd)
			end
		end)
		return
	end
	name = sanitize(name)
	if name == "" then
		notify("agent name must not be empty", vim.log.levels.WARN)
		return
	end
	local existing = find(name)
	if existing then
		M.toggle(name)
		return existing
	end
	local root = project_root()
	local agent =
		{ name = name, cmd = cmd, state = "idle", title = "", session_id = nil, spawned_at = nil, root = root }
	-- drop any stale status file from a previous life under the same name,
	-- otherwise the poll would immediately mark the fresh agent with the
	-- old state (e.g. "exited")
	vim.fn.delete(STATUS_DIR .. "/" .. name .. ".json")
	make_terminal(agent)
	table.insert(M.agents, agent)
	M._last = name
	start_timer()
	agent.term:toggle()
	-- fresh sessions get named inside kimi itself (/title) once the session
	-- exists — see poll(); resumed sessions already have their title
	if not cmd then
		agent._want_title = true
	end
	M.save_registry()
	refresh()
	return agent
end

function M.toggle(name)
	local agent = find(name)
	if not agent then
		notify("no agent named " .. name, vim.log.levels.WARN)
		return
	end
	if not agent.term then
		-- restored agent: first toggle resumes its kimi session
		make_terminal(agent)
	end
	agent.term:toggle()
	M._last = name
	refresh()
end

function M.toggle_last()
	local visible = visible_agents()
	local agent = (M._last and find(M._last)) or visible[#visible]
	if not agent then
		notify("no agents yet — <leader>kn to spawn one")
		return
	end
	M.toggle(agent.name)
end

---@param name string agent name (sidebar always passes one)
---@param force boolean|nil skip the confirm dialog
function M.kill(name, force)
	local agent, idx = find(name)
	if not agent then
		return
	end
	if not force and vim.fn.confirm("Kill agent '" .. name .. "'?", "&Yes\n&No", 2) ~= 1 then
		return
	end
	if agent.term then
		agent.term:shutdown()
	end
	-- tombstone the session so its late hook writes (SessionEnd fires on
	-- shutdown) can't leak into a future same-named agent
	if agent.session_id then
		M._dead_sessions[agent.session_id] = true
	end
	table.remove(M.agents, idx)
	if M._last == name then
		M._last = nil
	end
	vim.fn.delete(STATUS_DIR .. "/" .. name .. ".json")
	M.save_registry()
	refresh()
end

---Resume an existing kimi-code session of this project in a new agent float.
function M.resume()
	local root = project_root()
	local f = io.open(INDEX_FILE, "r")
	if not f then
		notify("no kimi session index found", vim.log.levels.WARN)
		return
	end
	local items = {}
	for line in f:lines() do
		local ok, rec = pcall(vim.json.decode, line)
		if ok and type(rec) == "table" and rec.sessionId and rec.workDir == root then
			local title = ""
			if rec.sessionDir then
				local sf = io.open(rec.sessionDir .. "/state.json", "r")
				if sf then
					local ok2, state = pcall(vim.json.decode, sf:read("*a"))
					sf:close()
					if ok2 and type(state) == "table" then
						title = state.title or state.lastPrompt or ""
					end
				end
			end
			local mtime = 0
			local stat = rec.sessionDir and vim.uv.fs_stat(rec.sessionDir .. "/state.json")
			if stat then
				mtime = stat.mtime.sec
			end
			table.insert(items, { id = rec.sessionId, title = title, mtime = mtime })
		end
	end
	f:close()
	if #items == 0 then
		notify("no kimi sessions for " .. root)
		return
	end
	table.sort(items, function(a, b)
		return a.mtime > b.mtime
	end)
	vim.ui.select(items, {
		prompt = "Resume kimi session",
		format_item = function(it)
			local label = it.title ~= "" and it.title or it.id:sub(9, 24)
			label = vim.fn.strcharpart(label:gsub("\n", " "), 0, 50)
			local when = it.mtime > 0 and os.date("%m-%d %H:%M", it.mtime) or "?"
			return string.format("%s  (%s)", label, when)
		end,
	}, function(choice)
		if not choice then
			return
		end
		local open = find_by_session(choice.id)
		if open then
			M.toggle(open.name)
			return
		end
		local name =
			vim.fn.strcharpart((choice.title ~= "" and choice.title or choice.id:sub(9, 24)):gsub("\n", " "), 0, 30)
		-- a live agent already holds this name: make it unique, otherwise
		-- spawn() would just toggle that agent and we'd corrupt its
		-- session_id/title below
		if find(name) then
			local base = vim.fn.strcharpart(name, 0, 24)
			name = base .. "-" .. choice.id:sub(9, 16)
			local n = 2
			while find(name) do
				name = base .. "-" .. n
				n = n + 1
			end
		end
		local agent = M.spawn(name, "kimi --session " .. vim.fn.shellescape(choice.id))
		if agent then
			agent.session_id = choice.id
			-- a previously killed session may be tombstoned; resurrect it
			M._dead_sessions[choice.id] = nil
			agent.title = vim.fn.strcharpart(choice.title:gsub("\n", " "), 0, 80)
			-- sessions previously run outside nvim (no KIMI_AGENT_NAME) leave a
			-- stale status file keyed by session id; the poll matches on
			-- session id too, so drop it to keep the resumed agent visible
			vim.fn.delete(STATUS_DIR .. "/" .. choice.id .. ".json")
			M.save_registry()
			refresh()
		end
	end)
end

-- -------------------------------------------------------------- statusline --

---Number of live (non-exited) agents; used by the heirline condition.
function M.count()
	return #visible_agents()
end

---@return integer running, integer total (live agents only)
function M.status()
	local running = 0
	local agents = visible_agents()
	for _, a in ipairs(agents) do
		if a.state == "running" then
			running = running + 1
		end
	end
	return running, #agents
end

-- ------------------------------------------------------------------- setup --

function M.setup()
	M.restore_registry()
	vim.api.nvim_create_autocmd("VimLeavePre", { callback = M.save_registry })
	local map = vim.keymap.set
	map("n", "<leader>k", M.toggle_last, { desc = "kimi: toggle last agent" })
	map("n", "<leader>kn", function()
		M.spawn()
	end, { desc = "kimi: new agent" })
	map("n", "<leader>kr", M.resume, { desc = "kimi: resume session" })
	map("n", "<leader>ka", M.sidebar_toggle, { desc = "kimi: agents sidebar" })
end

return M
