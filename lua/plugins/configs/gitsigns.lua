local present, gitsigns = pcall(require, "gitsigns")
if not present then
	return
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
		map("n", "<leader>gc", "<cmd>!git commit -m 'Update %'<CR>", { desc = "Git commit current file" })
	end,
}

gitsigns.setup(opts)
