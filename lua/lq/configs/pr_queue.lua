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

local function read_entry(path)
	local file = assert(io.open(path, "rb"))
	local raw = file:read("*a")
	file:close()
	local state = vim.json.decode(raw)
	assert(
		type(state) == "table" and type(state.repository) == "table",
		"Expected repository.owner/name/number in state.json"
	)
	local repo = state.repository
	local number = tonumber(repo.number)
	assert(number and number > 0 and number % 1 == 0, "Invalid PR number")
	assert(type(repo.owner) == "string" and type(repo.name) == "string", "Invalid repository identity")
	return {
		path = path,
		state = state,
		label = repo.owner .. "/" .. repo.name .. " #" .. number,
		updated = str(state.updated_at),
	}
end

---Read states afresh on each picker open; malformed/partial writes are skipped.
function M.read()
	local entries, invalid, errors = {}, 0, {}
	for _, path in ipairs(vim.fn.glob(M.root() .. "/**/state.json", false, true)) do
		local ok, entry = pcall(read_entry, path)
		if ok then
			table.insert(entries, entry)
		else
			invalid = invalid + 1
			table.insert(errors, path .. ": " .. tostring(entry))
		end
	end
	table.sort(entries, function(a, b)
		return a.updated == b.updated and a.label < b.label or a.updated > b.updated
	end)
	return entries, invalid, errors
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

function M.open_progress(entry)
	local ok, current = pcall(read_entry, entry.path)
	if not ok then
		notify("Cannot read the current PR state: " .. tostring(current))
		return
	end
	vim.cmd("tabnew")
	local buf = vim.api.nvim_get_current_buf()
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	vim.bo[buf].filetype = "prprogress"
	local expanded = false
	local function refresh()
		local loaded, latest = pcall(read_entry, entry.path)
		if not loaded then
			notify("Cannot refresh PR state: " .. tostring(latest))
			return
		end
		require("lq.configs.pr_progress").draw(buf, latest, expanded)
	end
	refresh()
	vim.wo.wrap = true
	vim.wo.linebreak = true
	vim.wo.number = false
	vim.wo.relativenumber = false
	vim.wo.winbar = "PR progress (saved) — r refresh · d evidence · q/Q return"
	for _, key in ipairs({ "q", "Q" }) do
		vim.keymap.set("n", key, "<cmd>tabclose<CR>", { buffer = buf, desc = "Return from PR progress" })
	end
	vim.keymap.set("n", "r", refresh, { buffer = buf, desc = "Refresh saved PR progress" })
	vim.keymap.set("n", "d", function()
		expanded = not expanded
		refresh()
	end, { buffer = buf, desc = "Toggle detailed PR evidence" })
end

function M.open()
	local entries, invalid, errors = M.read()
	if invalid > 0 then
		notify("Skipped " .. invalid .. " invalid state file(s):\n" .. table.concat(errors, "\n"))
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
			results_title = "Enter worktree · C-p progress · C-d diff · C-s JSON",
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
				title = "Saved progress and evidence (agent-reported)",
				define_preview = function(self, selected)
					require("lq.configs.pr_progress").draw(self.state.bufnr, selected.value, false)
					vim.bo[self.state.bufnr].filetype = "prprogress"
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
					["<C-p>"] = M.open_progress,
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
