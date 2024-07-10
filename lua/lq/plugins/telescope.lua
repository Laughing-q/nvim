return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			{
				"nvim-tree/nvim-web-devicons",
			},
		},
		config = function()
			require("lq.configs.telescope")
		end,
	},
}
