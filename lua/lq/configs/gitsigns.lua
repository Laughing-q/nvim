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

-- Function to generate GitHub commit URL
local function generate_github_commit_link()
	-- Get the blame information for the current line
	-- gitsigns.toggle_current_line_blame(true)
	local blame_info = vim.b.gitsigns_blame_line_dict
  -- for key, value in pairs(blame_info) do
  --     print(key, value)
  -- end

	if not blame_info or not blame_info.sha then
		print("No blame information available for current line")
		return
	end

	-- Try to get repo dynamically, fallback to hardcoded value
	local repo = get_git_repo() or "lewis6991/gitsigns.nvim"
	local commit_url = string.format("https://github.com/%s/commit/%s", repo, blame_info.sha)

	-- Copy to clipboard
	vim.fn.setreg("+", commit_url)
	print("Commit URL copied to clipboard: " .. commit_url)
	-- gitsigns.toggle_current_line_blame(false)

	return commit_url
end

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
	current_line_blame = true, -- Enable this for easier access to blame info

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
			generate_github_commit_link()
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
