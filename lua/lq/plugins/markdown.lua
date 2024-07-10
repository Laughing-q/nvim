return {
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		ft = { "markdown" },
	},
	{
		"dhruvasagar/vim-table-mode",
		ft = { "markdown" },
		cmd = { "TableModeToggle" },
		init = function()
			vim.g.table_mode_map_prefix = "<Leader>m"
			vim.g.table_mode_toggle_map = "m"
		end,
		config = function()
			require("lq.configs.markdown").table_mode()
		end,
	},
	{
		"mzlogin/vim-markdown-toc",
		ft = { "markdown" },
		cmd = { "GenTocGFM" },
		config = function()
			require("lq.configs.markdown").markdown_toc()
		end,
	},
	{
		"dkarter/bullets.vim",
		ft = { "markdown" },
	},
}
