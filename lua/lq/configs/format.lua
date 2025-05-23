vim.cmd [[
func! Format()
	if &filetype == 'bash'
		silent! exec "!shfmt -w %"
  elseif &filetype == 'sh'
		silent! exec "!shfmt -w %"
  elseif &filetype == 'python'
		" silent! exec "!black --fast --quiet -l 120 %"
		silent! exec "!ruff format --line-length 120 %"
	elseif &filetype == 'lua'
		silent! exec "!stylua --column-width 120 %"
	elseif &filetype == 'cpp'
		silent! exec "!clang-format --style=Microsoft -i %"
	elseif &filetype == 'cmake'
		silent! exec "!cmake-format --enable-markup -i %"
	elseif &filetype == 'json'
		silent! exec "!prettier -w %"
	elseif &filetype == 'yaml'
		silent! exec "!prettier -w %"
	endif
  :e!
endfunc
]]
-- :e!
