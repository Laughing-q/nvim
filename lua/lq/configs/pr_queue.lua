-- A read-only view of prepare-pr state. Agents own these files and readiness.
local M = {}

local function notify(message)
	vim.notify(message, vim.log.levels.WARN, { title = "PR queue" })
end

local function object(value)
	return type(value) == "table" and value or {}
end

local function str(value, fallback)
	return type(value) == "string" and value or fallback or ""
end

function M.root()
	return vim.fn.expand(vim.g.pr_queue_dir or "~/.local/state/agents/prs")
end

---Read states afresh on each picker open; malformed/partial writes are skipped.
function M.read()
	local entries, invalid = {}, 0
	for _, path in ipairs(vim.fn.glob(M.root() .. "/**/state.json", false, true)) do
		local ok, state = pcall(function()
			return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
		end)
		if ok and type(state) == "table" and type(state.repository) == "table" then
			local repo = state.repository
			local number = tonumber(repo.number)
			if
				number
				and number > 0
				and number % 1 == 0
				and type(repo.owner) == "string"
				and type(repo.name) == "string"
			then
				table.insert(entries, {
					path = path,
					state = state,
					label = repo.owner .. "/" .. repo.name .. " #" .. number,
					updated = str(state.updated_at),
				})
			else
				invalid = invalid + 1
			end
		else
			invalid = invalid + 1
		end
	end
	table.sort(entries, function(a, b)
		return a.updated == b.updated and a.label < b.label or a.updated > b.updated
	end)
	return entries, invalid
end

local function worktree(entry)
	local path = object(entry.state.workspace).worktree
	if type(path) ~= "string" or vim.fn.isdirectory(path) == 0 then
		notify("Worktree is missing; inspect the saved state with <C-s>")
		return
	end
	return path
end

local function command(name, args)
	local ok, err = pcall(vim.api.nvim_cmd, { cmd = name, args = args }, {})
	if not ok then
		notify(tostring(err))
	end
end

function M.open_worktree(entry)
	local path = worktree(entry)
	if path then
		vim.cmd("tcd " .. vim.fn.fnameescape(path))
		require("telescope.builtin").find_files({ cwd = path })
	end
end

function M.resume_owner(entry)
	local path = worktree(entry)
	if not path then
		return
	end
	local owner = object(object(entry.state.sessions).owner)
	if type(owner.id) ~= "string" or (owner.provider ~= "codex" and owner.provider ~= "kimi") then
		notify("Save sessions.owner = { provider = 'codex' or 'kimi', id = '<CLI session ID>' } first")
		return
	end
	require("lq.configs.agents").resume_session(owner.provider, owner.id, path, entry.label)
end

function M.open_diff(entry)
	local path = worktree(entry)
	if not path then
		return
	end
	local revisions = object(entry.state.revisions)
	local base, head = str(revisions.base), str(revisions.head)
	if #base < 7 or #head < 7 or not base:match("^%x+$") or not head:match("^%x+$") then
		notify("Save revisions.base and revisions.head as commit SHAs before opening the PR diff")
		return
	end
	command("CodeDiff", { "--repo", path, base .. "..." .. head })
end

local function preview(entry)
	local state = entry.state
	local owner = object(object(state.sessions).owner)
	local lines = {
		"# " .. entry.label,
		"",
		"Status: " .. str(state.status, "unknown") .. " (saved)",
		"Updated: " .. entry.updated,
		"Owner: " .. str(owner.provider, "not recorded"),
		"Worktree: " .. str(object(state.workspace).worktree, "not recorded"),
		"",
		"## Next action",
		str(state.next_action, "Not recorded"),
	}
	for _, section in ipairs({
		{ "Findings", state.findings },
		{ "Checks", state.checks },
		{ "Blockers", state.blockers },
	}) do
		vim.list_extend(lines, { "", "## " .. section[1] })
		local items = object(section[2])
		if #items == 0 then
			table.insert(lines, "None recorded")
		end
		for _, item in ipairs(items) do
			local text = type(item) == "string" and item or vim.inspect(item)
			vim.list_extend(lines, vim.split(text, "\n", { plain = true }))
			table.insert(lines, "")
		end
	end
	return lines
end

function M.open()
	local entries, invalid = M.read()
	if invalid > 0 then
		notify("Skipped " .. invalid .. " invalid state file(s) in " .. M.root())
	end
	if #entries == 0 then
		vim.notify("No saved PRs. Ask prepare-pr to write state.json under " .. M.root(), vim.log.levels.INFO)
		return
	end
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local previewers = require("telescope.previewers")
	require("telescope.pickers")
		.new({}, {
			prompt_title = "PR queue (saved agent state)",
			results_title = "Enter worktree · C-r owner · C-d diff · C-s state",
			finder = require("telescope.finders").new_table({
				results = entries,
				entry_maker = function(entry)
					local state = entry.state
					local label = entry.label .. "  " .. str(state.status, "unknown") .. "  " .. str(state.next_action)
					return { value = entry, display = label:gsub("[\r\n]", " "), ordinal = label }
				end,
			}),
			sorter = require("telescope.config").values.generic_sorter({}),
			previewer = previewers.new_buffer_previewer({
				title = "Findings, checks, and next action (not live GitHub verification)",
				define_preview = function(self, selected)
					vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, preview(selected.value))
					vim.bo[self.state.bufnr].filetype = "markdown"
				end,
			}),
			attach_mappings = function(prompt_bufnr, map)
				local function act(fn)
					return function()
						local selected = action_state.get_selected_entry()
						if not selected then
							return
						end
						actions.close(prompt_bufnr)
						fn(selected.value)
					end
				end
				actions.select_default:replace(act(M.open_worktree))
				for key, fn in pairs({
					["<C-r>"] = M.resume_owner,
					["<C-d>"] = M.open_diff,
					["<C-s>"] = function(entry)
						vim.cmd("view " .. vim.fn.fnameescape(entry.path))
					end,
				}) do
					map("i", key, act(fn))
					map("n", key, act(fn))
				end
				return true
			end,
		})
		:find()
end

return M
