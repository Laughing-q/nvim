-- uncomment this if you want to open nvim with a dir
-- vim.cmd [[ autocmd BufEnter * if &buftype != "terminal" | lcd %:p:h | endif ]]

-- Use relative & absolute line numbers in 'n' & 'i' modes respectively
-- vim.cmd[[ au InsertEnter * set norelativenumber ]]
-- vim.cmd[[ au InsertLeave * set relativenumber ]]

-- Don't show any numbers inside terminals
-- vim.cmd([[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]])
vim.cmd([[ au TermOpen term://* setlocal nonumber norelativenumber ]])

-- Don't show status line on certain windows
-- vim.cmd([[ autocmd BufEnter,BufWinEnter,FileType,WinEnter * lua require("utils").hide_statusline() ]])

-- Open a file from its last left off position
vim.cmd([[ au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]])
-- File extension specific tabbing
-- vim.cmd [[ autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4 ]]

-- Auto change directory to current dir
vim.cmd([[ autocmd BufEnter * silent! lcd %:p:h ]])

-- keep cursor at the same position
-- vim.cmd [[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]

-- clear tex compile stuff
vim.cmd([[ autocmd BufWinLeave *.tex silent !texclear %; ]])

-- yank highlight
vim.cmd([[ autocmd TextYankPost * silent lua require('vim.highlight').on_yank({higroup = 'Search', timeout = 200}) ]])

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

-- aerial keymappings
vim.cmd([[
    autocmd Filetype aerial nnoremap <buffer> ? <cmd>lua require'aerial.bindings'.show()<CR>
    autocmd Filetype aerial nnoremap <buffer> <CR> <cmd>lua require'aerial'.select()<CR>
    autocmd Filetype aerial nnoremap <buffer> p <cmd>lua require'aerial'.select({jump=false})<CR>
    autocmd Filetype aerial nnoremap <buffer> q <cmd>AerialClose<CR>

    autocmd Filetype aerial nnoremap <buffer> <C-v> <cmd>lua require'aerial'.select({split='v'})<CR>
    autocmd Filetype aerial nnoremap <buffer> <C-x> <cmd>lua require'aerial'.select({split='h'})<CR>

    autocmd Filetype aerial nnoremap <buffer> <A-k> j<cmd>lua require'aerial'.select({jump=false})<CR>
    autocmd Filetype aerial nnoremap <buffer> <A-i> k<cmd>lua require'aerial'.select({jump=false})<CR>

    autocmd Filetype aerial nnoremap <buffer> { <cmd>AerialPrev<CR>
    autocmd Filetype aerial nnoremap <buffer> } <cmd>AerialNext<CR>

    autocmd Filetype aerial nnoremap <buffer> l <cmd>AerialTreeToggle<CR>
    autocmd Filetype aerial nnoremap <buffer> L <cmd>AerialTreeToggle!<CR>
    autocmd Filetype aerial nnoremap <buffer> j <cmd>AerialTreeClose<CR>
    autocmd Filetype aerial nnoremap <buffer> J <cmd>AerialTreeClose!<CR>
]]
)
 --    { "zx", "zX" },
 --    "<cmd>AerialTreeSyncFolds<CR>",
 --    "Sync code folding to the tree (useful if they get out of sync)",
 --  },
 --
