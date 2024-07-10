return {
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VimEnter",
		config = function()
			require("ibl").setup({
				enabled = true,
				indent = { char = "▏" },
				scope = { enabled = false },
				exclude = {
					filetypes = {
						"help",
						"terminal",
						"dashboard",
						"packer",
						"lspinfo",
						"TelescopePrompt",
						"TelescopeResults",
					},
					buftypes = { "terminal" },
				},
				whitespace = {
					remove_blankline_trail = true,
				},
			})
		end,
	},
}
