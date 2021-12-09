local M = {}

M.setup = function ()
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
