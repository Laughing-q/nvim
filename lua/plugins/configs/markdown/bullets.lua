local M = {}

M.setup = function()
	vim.cmd([[
  let g:bullets_enabled_file_types = ['markdown', 'text', 'gitcommit', 'scratch']
  ]])
end
return M
