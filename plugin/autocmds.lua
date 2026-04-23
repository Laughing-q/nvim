-- uncomment this if you want to open nvim with a dir
-- vim.cmd [[ autocmd BufEnter * if &buftype != "terminal" | lcd %:p:h | endif ]]

-- Use relative & absolute line numbers in 'n' & 'i' modes respectively
-- vim.cmd[[ au InsertEnter * set norelativenumber ]]
-- vim.cmd[[ au InsertLeave * set relativenumber ]]

-- Don't show any numbers inside terminals
-- vim.cmd([[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]])
vim.cmd([[ au TermOpen term://* setlocal nonumber norelativenumber ]])

-- Open a file from its last left off position
vim.cmd(
	[[ au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]
)
-- File extension specific tabbing
-- vim.cmd [[ autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4 ]]

-- Auto change directory to current dir
vim.cmd([[ autocmd BufEnter * silent! lcd %:p:h ]])

-- keep cursor at the same position
-- vim.cmd [[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]

-- clear tex compile stuff
vim.cmd([[ autocmd BufWinLeave *.tex silent !texclear %; ]])

-- yank highlight
vim.cmd([[ autocmd TextYankPost * silent lua vim.highlight.on_yank({higroup = 'Search', timeout = 50}) ]])

-- markdown snippets
vim.cmd([[
    autocmd Filetype markdown inoremap <buffer> ,f <++>
    autocmd Filetype markdown inoremap <buffer> ,n ---<Enter><Enter>
    autocmd Filetype markdown inoremap <buffer> ,b **** <++><Esc>F*hi
    autocmd Filetype markdown inoremap <buffer> ,sb <sub></sub> <++><Esc>Fs2hi
    autocmd Filetype markdown inoremap <buffer> ,sp <sup></sup> <++><Esc>Fs2hi
    autocmd Filetype markdown inoremap <buffer> ,i ** <++><Esc>F*i
    autocmd Filetype markdown inoremap <buffer> ,d `` <++><Esc>F`i
    autocmd Filetype markdown inoremap <buffer> ,c ```<Enter><++><Enter>```<Enter><Enter><++><Esc>4kA
    autocmd Filetype markdown inoremap <buffer> ,m - [ ] 
    autocmd Filetype markdown inoremap <buffer> ,p ![](<++>) <++><Esc>F[a
    autocmd Filetype markdown inoremap <buffer> ,a [](<++>) <++><Esc>F[a
    autocmd Filetype markdown inoremap <buffer> ,1 #<Space><Enter><++><Esc>kA
    autocmd Filetype markdown inoremap <buffer> ,2 ##<Space><Enter><++><Esc>kA
    autocmd Filetype markdown inoremap <buffer> ,3 ###<Space><Enter><++><Esc>kA
    autocmd Filetype markdown inoremap <buffer> ,4 ####<Space><Enter><++><Esc>kA
    autocmd Filetype markdown inoremap <buffer> ,l --------<Enter>
    autocmd Filetype markdown inoremap <buffer> ,l --------<Enter>
    autocmd Filetype markdown inoremap <buffer> ,w <details><Enter><summary></summary><Enter><Enter><++><Enter></details><Esc>3ki
  ]])

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})
