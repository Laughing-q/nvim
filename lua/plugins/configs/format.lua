vim.cmd [[
func! Format()
	if &filetype == 'sh'
		silent! exec "!shfmt -w %"
  elseif &filetype == 'python'
		silent! exec "!black --fast --quiet %"
	elseif &filetype == 'lua'
		silent! exec "!stylua %"
	elseif &filetype == 'cpp'
		silent! exec "!clang-format --style=Microsoft -i %"
	elseif &filetype == 'cmake'
		silent! exec "!cmake-format --enable-markup -i %"
	endif
  :e!
endfunc
]]
-- :e!
