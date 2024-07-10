return {
	{
		"folke/tokyonight.nvim",
		enabled = false,
		config = function()
			require("tokyonight").setup({
				style = "storm",
				transparent = false,
				terminal_colors = true,
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
				sidebars = { "qf", "help" },

				on_highlights = function(hl, c)
					hl.LineNr = {
						fg = "#bb9af7",
					}
					hl.BufferLineFill = {
						bg = c.black,
					}
				end,
			})
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		enabled = true,
	},
}
