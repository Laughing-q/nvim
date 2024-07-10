return {
	{
		"stevearc/aerial.nvim",
		cmd = "AerialToggle",
		config = function()
			require("lq.configs.aerial")
		end,
		{
			"lervag/vimtex",
			ft = { "tex" },
			config = function()
				vim.g.vimtex_view_method = "zathura"
				vim.g.vimtex_compiler_progname = "xelatex"
				-- vim.g.vimtex_compiler_latexmk_engines='xelatex'
			end,
		},
	},
}
