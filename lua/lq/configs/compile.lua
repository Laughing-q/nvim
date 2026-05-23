vim.cmd([[
func! RunPytestUnderCursor()
	exec "w"
	let l:file = expand('%:p')
	let l:save_pos = getpos('.')

	" Find nearest function definition above cursor
	let l:func_line = search('^\s*def\s', 'bnW')
	if l:func_line == 0
		echo "No function found under cursor"
		call setpos('.', l:save_pos)
		return
	endif

	let l:func_content = getline(l:func_line)
	let l:func_name = matchstr(l:func_content, '^\s*def\s\+\zs\w\+')

	" Check if inside a class (class line must be above the function)
	let l:class_name = ""
	let l:class_line = search('^\s*class\s', 'bnW')
	if l:class_line > 0 && l:class_line < l:func_line
		let l:class_content = getline(l:class_line)
		let l:class_name = matchstr(l:class_content, '^\s*class\s\+\zs\w\+') . '::'
	endif

	call setpos('.', l:save_pos)

	let l:test_path = l:file . '::' . l:class_name . l:func_name

	set splitbelow
	:sp
	:execute 'term pytest -vv -s ' . l:test_path
	:$
endfunc

func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'cpp'
		set splitbelow
		exec "!g++ -std=c++11 % -Wall -o %<"
		:sp
		:res -15
		:term ./%<
	elseif &filetype == 'java'
		exec "!javac %"
		exec "!time java %<"
	elseif &filetype == 'sh'
		:!time bash %
  elseif &filetype == 'python'
    set splitbelow
    :sp
    :term python3 %
    :$
	elseif &filetype == 'html'
		silent! exec "!".g:mkdp_browser." % &"
	elseif &filetype == 'markdown'
		exec "MarkdownPreview"
	elseif &filetype == 'tex'
		silent! exec "VimtexStop"
		silent! exec "VimtexCompile"
	elseif &filetype == 'dart'
		exec "CocCommand flutter.run -d ".g:flutter_default_device." ".g:flutter_run_args
		silent! exec "CocCommand flutter.dev.openDevLog"
	elseif &filetype == 'javascript'
		set splitbelow
		:sp
		:term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
	elseif &filetype == 'go'
		set splitbelow
		:sp
		:term go run .
	elseif &filetype == 'lua'
    :luafile %
	elseif &filetype == 'cmake'
		set splitbelow
		:sp
    :term cmake_build . build
    :$
	endif
endfunc
]])
