return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "mason.nvim", config = true },
		event = "VeryLazy",
		config = function()
			require("lq.configs.lsp.lspconfig")
			vim.cmd("silent! do FileType")
		end,
	},
	{
		"nvimdev/lspsaga.nvim",
		event = "VeryLazy",
		config = function()
			require("lq.configs.lspsaga")
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},
}
