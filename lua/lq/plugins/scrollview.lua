return {
	{
		"dstein64/nvim-scrollview",
		event = "VeryLazy",
		config = function()
			require("scrollview").setup({
				-- excluded_filetypes = { "nerdtree" },
				current_only = true,
				winblend = 75,
				base = "right",
				-- column = 80,
				signs_on_startup = { "search" }, -- search, diagnostic
				-- diagnostics_severities = { vim.diagnostic.severity.ERROR },
				search_symbol = "-",
			})
		end,
	},
}
