local M = {}

-- some global setting
-- cause some plugins load in some filetype only, some global setting won't load ad first.

-- Example:
-- vim-table-mode plugin load in `markdown` only, so setting from below won't load at first.
-- vim.g.table_mode_map_prefix = '<Leader>m'
-- vim.g.table_mode_toggle_map = 'm'
M.setup = function()
	-- vim-table-mode
	vim.g.table_mode_map_prefix = "<Leader>m"
	vim.g.table_mode_toggle_map = "m"

	-- -- vim-markdown-toc
	-- vim.g.vmt_auto_update_on_save = 1
	-- vim.g.vmt_dont_insert_fence = 1
	-- vim.g.vmt_cycle_list_item_markers = 1
	-- vim.g.vmt_fence_text = 'TOC'
	-- vim.g.vmt_fence_closing_text = '/TOC'

	-- tokyonight
	-- vim.g.tokyonight_style = 'storm'
	vim.g.tokyonight_transparent = true
	vim.g.tokyonight_line_number_color = "#bb9af7"
	vim.g.tokyonight_transparent_sidebar = true

  -- kanagawa
  -- require('kanagawa').setup({transparent = true})

	-- vimtex
	-- vim.g.vimtex_view_method = 'zathura'

	-- nvim-scrollview
	vim.g.scrollview_current_only = true

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
end

return M
