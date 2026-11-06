-- Switch this tab entirely into a git worktree (cwd + file picker), bound to
-- <leader>gw in plugin/keymappings.lua.
--
-- Worktrees are listed by "recently changed" -- the newest of the last commit
-- and the uncommitted file edits (agents often leave work uncommitted) -- with
-- a dirty marker, branch, relative age and the [current] tag. Every worktree
-- is scanned with async git calls (vim.system) so the popup waits for the
-- slowest scan instead of the sum; the picker opens via vim.schedule because
-- vim.system's on_exit runs in a fast event.

local M = {}

local function list_worktrees()
	local root = vim.fs.root(0, ".git") or vim.fn.getcwd()
	local out = vim.fn.system({ "git", "-C", root, "worktree", "list", "--porcelain" })
	if vim.v.shell_error ~= 0 then
		return {}
	end
	local trees, current = {}, nil
	for line in out:gmatch("[^\n]+") do
		local path = line:match("^worktree (.+)$")
		if path then
			current = { path = vim.fs.normalize(path) }
			table.insert(trees, current)
		elseif current then
			local branch = line:match("^branch refs/heads/(.+)$")
			if branch then
				current.branch = branch
			elseif line == "detached" or line == "bare" then
				current.branch = line
			end
		end
	end
	return trees
end

-- uncommitted edits count toward recency too, not just commits
local function worktree_activity(t, done)
	local pending = 2
	local commit, status, status_ok
	local function finish()
		pending = pending - 1
		if pending > 0 then
			return
		end
		local newest = commit or 0
		t.dirty = status_ok and status ~= ""
		for line in status:gmatch("[^\n]+") do
			local file = line:sub(4)
			file = file:match(" -> (.+)$") or file
			local stat = vim.uv.fs_stat(t.path .. "/" .. file)
			if stat and stat.mtime.sec > newest then
				newest = stat.mtime.sec
			end
		end
		t.age = os.time() - newest
		done()
	end
	vim.system({ "git", "-C", t.path, "log", "-1", "--format=%ct" }, {}, function(obj)
		commit = tonumber(obj.stdout) or 0
		finish()
	end)
	vim.system({ "git", "-C", t.path, "-c", "core.quotePath=false", "status", "--porcelain" }, {}, function(obj)
		status, status_ok = obj.stdout, obj.code == 0
		finish()
	end)
end

local function age_label(age)
	if age < 60 then
		return "just now"
	elseif age < 3600 then
		return math.floor(age / 60) .. "m ago"
	elseif age < 86400 then
		return math.floor(age / 3600) .. "h ago"
	elseif age < 2592000 then
		return math.floor(age / 86400) .. "d ago"
	elseif age < 31536000 then
		return math.floor(age / 2592000) .. "mo ago"
	end
	return math.floor(age / 31536000) .. "y ago"
end

local function open_worktree_picker(trees)
	local cwd = vim.fs.normalize(vim.fn.getcwd())
	local name_width, branch_width = 0, 0
	for _, t in ipairs(trees) do
		t.name = vim.fn.fnamemodify(t.path, ":t")
		t.branch = t.branch or "?"
		t.current = cwd == t.path or vim.startswith(cwd, t.path .. "/")
		name_width = math.max(name_width, vim.fn.strdisplaywidth(t.name))
		branch_width = math.max(branch_width, vim.fn.strdisplaywidth(t.branch))
	end
	table.sort(trees, function(a, b)
		return a.age < b.age
	end)

	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local conf = require("telescope.config").values
	local entry_display = require("telescope.pickers.entry_display")
	local finders = require("telescope.finders")
	local pickers = require("telescope.pickers")
	local sorters = require("telescope.sorters")

	local displayer = entry_display.create({
		separator = "  ",
		items = {
			{ width = 1 },
			{ width = name_width },
			{ width = branch_width },
			{ width = 8 },
			{ remaining = true },
		},
	})

	-- telescope sorts lower scores first, so age is the score: most recently
	-- changed worktree on top; the generic sorter keeps telescope's fuzzy filtering
	local generic_sorter = conf.generic_sorter({})
	pickers
		.new({}, {
			prompt_title = "Git Worktrees",
			finder = finders.new_table({
				results = trees,
				entry_maker = function(tree)
					return {
						value = tree,
						ordinal = tree.name .. " " .. tree.branch,
						age = tree.age,
						display = function(entry)
							local t = entry.value
							return displayer({
								t.dirty and { "●", "WarningMsg" } or "",
								{ t.name, "TelescopeResultsIdentifier" },
								{ t.branch, "TelescopeResultsComment" },
								{ age_label(t.age), "TelescopeResultsComment" },
								t.current and { "[current]", "Special" } or "",
							})
						end,
					}
				end,
			}),
			sorter = sorters.Sorter:new({
				init = function()
					generic_sorter:_init()
				end,
				destroy = function()
					generic_sorter:_destroy()
				end,
				scoring_function = function(_, prompt, _, entry)
					if prompt ~= "" and generic_sorter:scoring_function(prompt, entry.ordinal, entry) < 0 then
						return -1
					end
					return entry.age
				end,
				highlighter = function(_, prompt, display)
					return generic_sorter:highlighter(prompt, display)
				end,
			}),
			previewer = false,
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					local t = action_state.get_selected_entry().value
					actions.close(prompt_bufnr)
					vim.cmd("tcd " .. vim.fn.fnameescape(t.path))
					vim.notify("worktree → " .. t.path)
					require("telescope.builtin").find_files({ cwd = t.path })
				end)
				return true
			end,
		})
		:find()
end

-- scan every worktree at once, open the picker when the slowest scan finishes
function M.switch_worktree()
	local trees = list_worktrees()
	if #trees == 0 then
		vim.notify("no git worktrees found", vim.log.levels.WARN)
		return
	end
	local remaining = #trees
	for _, t in ipairs(trees) do
		worktree_activity(t, function()
			remaining = remaining - 1
			if remaining == 0 then
				vim.schedule(function()
					open_worktree_picker(trees)
				end)
			end
		end)
	end
end

return M
