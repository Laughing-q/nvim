return {
	{ -- Additional text objects via treesitter
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "VimEnter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			event = "VimEnter",
			config = function()
				require("lq.configs.treesitter")
			end,
			dependencies = { "nvim-lua/plenary.nvim" },
		},
	},
}
