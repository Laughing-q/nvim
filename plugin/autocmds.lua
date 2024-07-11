-- uncomment this if you want to open nvim with a dir
-- vim.cmd [[ autocmd BufEnter * if &buftype != "terminal" | lcd %:p:h | endif ]]

-- Use relative & absolute line numbers in 'n' & 'i' modes respectively
-- vim.cmd[[ au InsertEnter * set norelativenumber ]]
-- vim.cmd[[ au InsertLeave * set relativenumber ]]

-- Don't show any numbers inside terminals
-- vim.cmd([[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]])
vim.cmd([[ au TermOpen term://* setlocal nonumber norelativenumber ]])

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
vim.cmd([[ autocmd TextYankPost * silent lua vim.highlight.on_yank({higroup = 'Search', timeout = 50}) ]])
