return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "mason.nvim", config = true },
		event = "VeryLazy",
    commit = "5bfcc89fd155b4ffc02d18ab3b7d19c2d4e246a7",
		config = function()
			require("lq.configs.lsp.lspconfig")
			vim.cmd("silent! do FileType")
		end,
	},
}
