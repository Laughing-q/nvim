return {
	{
		"esmuellert/codediff.nvim",
		cmd = "CodeDiff",
		opts = {
			diff = { layout = "inline", compact = true },
			explorer = { view_mode = "tree", width = 36 },
			keymaps = {
				view = { quit = { "q", "Q" } },
				-- Keep i = up and K = window down from the user's global maps.
				explorer = { toggle_view_mode = "gv", hover = "gK" },
				history = { toggle_view_mode = "gV" },
			},
		},
		keys = {
			{ "<leader>gD", "<cmd>CodeDiff<CR>", desc = "Git: unified changes" },
		},
	},
}
