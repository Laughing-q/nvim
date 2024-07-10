local M = {}

-- some global setting
-- cause some plugins load in some filetype only, some global setting won't load at first.

-- Example:
-- vim-table-mode plugin load in `markdown` only, so setting from below won't load at first.
-- vim.g.table_mode_map_prefix = '<Leader>m'
-- vim.g.table_mode_toggle_map = 'm'

local tokyonight_setpup = function()
	local present, tokyonight = pcall(require, "tokyonight")

	if not present then
		return
	end

	tokyonight.setup({
		style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
		transparent = false, -- Enable this to disable setting the background color
		terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
		styles = {
			sidebars = "transparent", -- style for sidebars, see below
			floats = "transparent", -- style for floating windows
		},
		sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`

		on_highlights = function(hl, c)
			hl.LineNr = {
				fg = "#bb9af7",
			}
			hl.BufferLineFill = {
				bg = c.black,
			}
		end,
	})
end

M.setup = function(colorscheme)
	--------------colorscheme-------------
	-- -- tokyonight
	if colorscheme == "tokyonight" then
		tokyonight_setpup()
	end
end

return M
