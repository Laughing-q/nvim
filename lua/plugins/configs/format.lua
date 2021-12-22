vim.cmd [[
func! Format()
	if &filetype == 'sh'
		silent! exec "!shfmt -w %"
  elseif &filetype == 'python'
		silent! exec "!black --fast --quiet %"
	elseif &filetype == 'lua'
		silent! exec "!stylua %"
	endif
  :e!
endfunc
]]
-- :e!
