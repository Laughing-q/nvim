return {
	{
		"folke/snacks.nvim",
		event = "VeryLazy",
		opts = {
			gitbrowse = { enabled = true, what = "permalink" },
		},
		keys = {
			{
				"<leader>gb",
				function()
					Snacks.gitbrowse.open({
						open = function(url)
							vim.fn.setreg("+", url)
							vim.notify("Yanked url to clipboard")
						end,
					})
				end,
				desc = "Git Copy Link",
				mode = { "n", "v" },
			},
		},
	},
}
