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
}
