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
  -- for k, v in pairs(result) do
  --   print(k, v)
  -- end
	local commit_url = string.format("https://github.com/%s/commit/%s", repo, result.sha)

	-- Copy to clipboard
	vim.fn.setreg("+", commit_url)
	print("Commit URL copied to clipboard: " .. commit_url)
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
	current_line_blame = false, -- Enable this for easier access to blame info

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

		-- -- Optional: Add keymap to open the link in browser if you have a plugin for it
		-- vim.keymap.set("n", "<leader>go", function()
		-- 	local url = generate_github_commit_link()
		-- 	if url and vim.fn.exists(":OpenBrowser") > 0 then
		-- 		vim.cmd("OpenBrowser " .. url)
		-- 	end
		-- end, { buffer = bufnr, desc = "Open GitHub link for current line's commit" })
	end,
}

gitsigns.setup(opts)
