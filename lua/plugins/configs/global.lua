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
		-- your configuration comes here
		-- or leave it empty to use the default settings
		style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
		-- light_style = "day", -- The theme is used when the background is set to light
		transparent = false, -- Enable this to disable setting the background color
		terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
		styles = {
			-- Style to be applied to different syntax groups
			-- Value is any valid attr-list value for `:help nvim_set_hl`
			comments = { italic = true },
			keywords = { italic = true },
			functions = { italic = true },
			variables = {},
			-- Background styles. Can be "dark", "transparent" or "normal"
			sidebars = "transparent", -- style for sidebars, see below
			floats = "transparent", -- style for floating windows
		},
		sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
		-- day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
		-- hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
		dim_inactive = false, -- dims inactive windows
		lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
		-- on_colors = function(colors)
		-- end,

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

	-- kanagawa
	-- set barbar highlight for kanagawa
	if colorscheme == "kanagawa" then
		-- require('kanagawa').setup({transparent = true})
		vim.cmd([[hi BufferCurrent guibg=#363646]])
		vim.cmd([[hi BufferCurrentSign guibg=#363646]])
		vim.cmd([[hi BufferCurrentMod guibg=#363646]])
		vim.cmd([[hi BufferCurrentMod guifg=#E5AB0E]])
	end

	--------------plugins-------------
	-- vim-table-mode
	vim.g.table_mode_map_prefix = "<Leader>m"
	vim.g.table_mode_toggle_map = "m"

	-- -- vim-markdown-toc
	-- vim.g.vmt_auto_update_on_save = 1
	-- vim.g.vmt_dont_insert_fence = 1
	-- vim.g.vmt_cycle_list_item_markers = 1
	-- vim.g.vmt_fence_text = 'TOC'
	-- vim.g.vmt_fence_closing_text = '/TOC'

	-- vimtex
	-- vim.g.vimtex_view_method = 'zathura'

	-- vim-visual-multi
	vim.api.nvim_exec(
		[[
      let g:VM_leader                     = {'default': ',', 'visual': ',', 'buffer': ','}
      let g:VM_maps                       = {}
      let g:VM_custom_motions             = {'j': 'h', 'l': 'l', 'i': 'k', 'k': 'j', 'J': '0', 'L': '$', 'h': 'e'}
      let g:VM_maps['i']                  = 'h'
      let g:VM_maps['I']                  = 'H'
      let g:VM_maps['Find Under']         = '<C-k>'
      let g:VM_maps['Find Subword Under'] = '<C-k>'
      let g:VM_maps['Find Next']          = '='
      let g:VM_maps['Find Prev']          = '-'
      let g:VM_maps['Remove Region']      = 'q'
      let g:VM_maps['Skip Region']        = '<c-n>'
      "let g:VM_maps["Undo"]              = 'l'
      let g:VM_maps["Redo"]               = '<C-r>'
    ]],
		false
	)

	-- nvim-scrollview
	vim.api.nvim_exec(
		[[
      hi ScrollView ctermbg=159 guibg=LightCyan
    ]],
		false
	)
	vim.g.scrollview_winblend = 80
	vim.g.scrollview_hide_on_intersect = true
	vim.g.scrollview_character = ""
	vim.g.scrollview_current_only = true
end

return M
