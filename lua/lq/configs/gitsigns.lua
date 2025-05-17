local present, gitsigns = pcall(require, "gitsigns")
if not present then
	return
end

-- Function to get repository from git remote
local function get_git_repo()
	local handle = io.popen("git remote get-url origin 2>/dev/null")
	if not handle then
		return nil
	end

	local result = handle:read("*a")
	handle:close()

	-- Extract repo from different GitHub URL formats
	local repo = result:match("github%.com[:/]([^/]+/[^/%.]+)")
	return repo and repo:gsub("%.git$", "") or nil
end

-- reference the source code of gitsigns.nvim repo
local async = require("gitsigns.async")
local git_blame_link = async.create(1, function()
	local cache = require("gitsigns.cache").cache
	local bcache = cache[vim.api.nvim_get_current_buf()]
	if not bcache then
		return
	end

	local util = require("gitsigns.util")
	local lnum = vim.api.nvim_win_get_cursor(0)[1]

	local repo = get_git_repo() or "lewis6991/gitsigns.nvim"
	local result = util.convert_blame_info(assert(bcache:get_blame(lnum, {})))
	local pr_number = result.summary:match("#(%d+)") -- match the PR number "#123"
	local url = nil
	if pr_number then
		url = string.format("https://github.com/%s/pull/%s", repo, pr_number)
	elseif result.sha:match("^0+$") == nil then  -- "sha" would be all zero values if not commit yet
		url = string.format("https://github.com/%s/commit/%s", repo, result.sha)
	end
	if url ~= nil then
		-- Copy to clipboard
		-- vim.fn.setreg("+", url)
		-- print("Commit URL copied to clipboard: " .. url)
		vim.fn.system({ "xdg-open", url }) -- Open the URL in the default browser
	else
		print("Not a commit or PR")
	end
end)

local opts = {
	signs = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signs_staged = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	-- signs = {
	-- 	add = {
	-- 		text = "+",
	--      -- text = "▎",
	-- 	},
	-- 	change = {
	-- 		text = "~",
	--      -- text = "▎",
	-- 	},
	-- },
	numhl = true,
	linehl = false,
	watch_gitdir = {
		interval = 1000,
		follow_files = true,
	},
	sign_priority = 6,
	update_debounce = 200,
	status_formatter = nil, -- Use default
	current_line_blame = false, -- disable this as it's a bit annoying
	preview_config = {
		border = "rounded",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},

	on_attach = function(bufnr)
		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]g", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end)

		map("n", "[g", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end)

		-- Actions
		map("n", "<leader>gl", gitsigns.blame_line, { desc = "Git Blame" })
		map("n", "<leader>gj", gitsigns.toggle_linehl, { desc = "Toggle Line Highlight" })
		map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Git Preview Hunk" })

		map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Git reset hunk" })
		map("v", "<leader>gr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Git reset hunk" })
		map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Git reset buffer" })
		map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Git stage hunk" })
		map("v", "<leader>gs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Git stage hunk" })
		map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Git undo stage" })
		map("n", "<leader>gd", gitsigns.diffthis, { desc = "Git diff" })
		map("n", "<leader>gc", "<cmd>silent !git commit -m 'Update %:t'<CR>", { desc = "Git commit current file" })
		map(
			"n",
			"<leader>gC",
			"<cmd>silent !git add % && git commit -m 'Update %:t'<CR>",
			{ desc = "Git commit current file" }
		)

		-- Add custom keymap for generating GitHub links
		vim.keymap.set("n", "<leader>gL", function()
			git_blame_link()
		end, { buffer = bufnr, desc = "Generate GitHub link for current line's commit" })
	end,
}

gitsigns.setup(opts)
