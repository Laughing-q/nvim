-- Multi-agent manager for kimi-code CLI sessions running in toggleterm floats.
--
-- Each agent is a named toggleterm Terminal (float). Status (running / idle /
-- interrupted / exited) comes from kimi-code hooks (see scripts/agent-status.sh),
-- which write $KIMI_CODE_HOME/agent-status/<name>.json; a timer polls that
-- directory and refreshes the sidebar and the heirline component.
-- Exited agents stay in the registry (so their float can still be toggled)
-- but are hidden from the sidebar, picker and statusline.

local M = {}

---@class KimiAgent
---@field name string
---@field term table toggleterm Terminal
---@field state "running"|"idle"|"interrupted"|"exited"
---@field title string
---@field session_id string|nil
---@field spawned_at integer|nil os.time() at spawn, used to ignore stale status files

---@type KimiAgent[]
M.agents = {}

local KIMI_HOME = vim.env.KIMI_CODE_HOME or (vim.fn.expand("~/.kimi-code"))
local STATUS_DIR = KIMI_HOME .. "/agent-status"
local INDEX_FILE = KIMI_HOME .. "/session_index.jsonl"

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

M._last = nil ---@type string|nil
M._next_count = 101
M._timer = nil
M._sidebar = { buf = nil, win = nil, line_map = {} }

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
				local agent = (status.name and find(status.name))
					or (status.session_id and find_by_session(status.session_id))
				-- ignore status written before this agent was spawned (stale
				-- file from a previous life under the same name/session)
				if agent and status.ts and agent.spawned_at and status.ts < agent.spawned_at then
					agent = nil
				end
				if agent then
					if status.state and agent.state ~= status.state then
						agent.state = status.state
						changed = true
					end
					if status.session_id and status.session_id ~= "" and not agent.session_id then
						agent.session_id = status.session_id
						changed = true
					end
					if status.title and status.title ~= "" and agent.title ~= status.title then
						agent.title = status.title
						changed = true
					end
				end
			end
		end
	end
	if changed then
		refresh()
	end
end

local function start_timer()
	if M._timer then
		return
	end
	M._timer = vim.uv.new_timer()
	M._timer:start(
		1000,
		2000,
		vim.schedule_wrap(function()
			if #M.agents == 0 then
				M._timer:stop()
				M._timer:close()
				M._timer = nil
				return
			end
			pcall(poll)
		end)
	)
end

-- ---------------------------------------------------------------- sidebar --

local PREVIEW_LINES = 2

local function preview_lines(agent)
	local term = agent.term
	if not term.bufnr or not vim.api.nvim_buf_is_valid(term.bufnr) then
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

function M._render_sidebar()
	local sb = M._sidebar
	if not sb.buf or not vim.api.nvim_buf_is_valid(sb.buf) then
		return
	end
	local agents = visible_agents()
	local lines = { "Kimi Agents (" .. #agents .. ")", "" }
	local hls = {}
	sb.line_map = {}
	if #agents == 0 then
		table.insert(lines, "  no agents — n to spawn")
	end
	for _, a in ipairs(agents) do
		local header = string.format("%s %s [%s]", STATE_ICON[a.state] or "?", a.name, a.state)
		sb.line_map[#lines + 1] = a.name
		table.insert(lines, header)
		table.insert(hls, { line = #lines - 1, hl = STATE_HL[a.state] or "Comment" })
		if a.title ~= "" then
			table.insert(lines, "  " .. a.title)
		end
		for _, p in ipairs(preview_lines(a)) do
			table.insert(lines, "  │ " .. p:sub(1, 60))
		end
		table.insert(lines, "")
	end
	vim.bo[sb.buf].modifiable = true
	vim.api.nvim_buf_set_lines(sb.buf, 0, -1, false, lines)
	vim.api.nvim_buf_clear_namespace(sb.buf, -1, 0, -1)
	for _, h in ipairs(hls) do
		vim.api.nvim_buf_add_highlight(sb.buf, -1, h.hl, h.line, 0, 1)
	end
	vim.bo[sb.buf].modifiable = false
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
		vim.keymap.set("n", "d", function()
			local name = sidebar_agent_at_cursor()
			if name then
				M.kill(name)
			end
		end, vim.tbl_extend("force", opts, { desc = "kill agent" }))
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
	end
	vim.cmd("botright 34vsplit")
	sb.win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(sb.win, sb.buf)
	vim.wo[sb.win].winfixwidth = true
	vim.wo[sb.win].number = false
	vim.wo[sb.win].relativenumber = false
	vim.wo[sb.win].signcolumn = "no"
	vim.wo[sb.win].wrap = false
	M._render_sidebar()
end

-- -------------------------------------------------------------- lifecycle --

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
	local Terminal = require("toggleterm.terminal").Terminal
	local agent = { name = name, state = "idle", title = "", session_id = nil, spawned_at = os.time() }
	-- drop any stale status file from a previous life under the same name,
	-- otherwise the poll would immediately mark the fresh agent with the
	-- old state (e.g. "exited")
	vim.fn.delete(STATUS_DIR .. "/" .. name .. ".json")
	agent.term = Terminal:new({
		cmd = cmd or "kimi",
		direction = "float",
		count = next_count(),
		display_name = name,
		dir = project_root(),
		env = { KIMI_AGENT_NAME = name },
		on_exit = function()
			agent.state = "exited"
			refresh()
		end,
	})
	table.insert(M.agents, agent)
	M._last = name
	start_timer()
	agent.term:toggle()
	refresh()
	return agent
end

function M.toggle(name)
	local agent = find(name)
	if not agent then
		notify("no agent named " .. name, vim.log.levels.WARN)
		return
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

function M.kill(name, force)
	if not name then
		M.pick("Kill agent", function(choice)
			M.kill(choice)
		end)
		return
	end
	local agent, idx = find(name)
	if not agent then
		return
	end
	if not force and vim.fn.confirm("Kill agent '" .. name .. "'?", "&Yes\n&No", 2) ~= 1 then
		return
	end
	agent.term:shutdown()
	table.remove(M.agents, idx)
	if M._last == name then
		M._last = nil
	end
	vim.fn.delete(STATUS_DIR .. "/" .. name .. ".json")
	refresh()
end

---@param prompt string|nil
---@param cb fun(name:string)|nil defaults to toggling
function M.pick(prompt, cb)
	local agents = visible_agents()
	if #agents == 0 then
		notify("no agents yet — <leader>kn to spawn one")
		return
	end
	vim.ui.select(agents, {
		prompt = prompt or "Kimi agents",
		format_item = function(a)
			local title = a.title ~= "" and (" — " .. a.title) or ""
			return string.format("%s %s [%s]%s", STATE_ICON[a.state] or "?", a.name, a.state, title)
		end,
	}, function(choice)
		if choice then
			(cb or function(name)
				M.toggle(name)
			end)(choice.name)
		end
	end)
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
			label = label:gsub("\n", " "):sub(1, 50)
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
		local name = (choice.title ~= "" and choice.title or choice.id:sub(9, 24)):gsub("\n", " "):sub(1, 30)
		local agent = M.spawn(name, "kimi --session " .. vim.fn.shellescape(choice.id))
		if agent then
			agent.session_id = choice.id
			agent.title = choice.title:gsub("\n", " "):sub(1, 80)
			-- the previous life of this session left an "exited" status file
			-- behind (keyed by session id); drop it so the poll doesn't hide
			-- the resumed agent
			vim.fn.delete(STATUS_DIR .. "/" .. choice.id .. ".json")
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
	local map = vim.keymap.set
	map("n", "<leader>k", M.toggle_last, { desc = "kimi: toggle last agent" })
	map("n", "<leader>kn", function()
		M.spawn()
	end, { desc = "kimi: new agent" })
	map("n", "<leader>kr", M.resume, { desc = "kimi: resume session" })
	map("n", "<leader>ka", M.sidebar_toggle, { desc = "kimi: agents sidebar" })
	map("n", "<leader>kl", function()
		M.pick()
	end, { desc = "kimi: list agents" })
	map("n", "<leader>kx", function()
		M.kill()
	end, { desc = "kimi: kill agent" })
end

return M
