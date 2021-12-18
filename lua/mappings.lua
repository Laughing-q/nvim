local map = require("utils").map

vim.g.mapleader = " " --leader
-------------base mappings---------------
-- cursor movement
map("", "i", "k")
map("", "k", "j")
map("", "j", "h")
map("", "h", "i")
map("", "gi", "gk")
map("", "gk", "gj")
map("", "gh", "gi")
-- Remap for dealing with word wrap
-- map("", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
-- map("", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

map("", "I", "5k")
map("", "K", "5j")
map("", "J", "5h")
map("", "L", "5l")
map("", "H", "I")

-- enter, quit and save
map("n", "O", "o<ESC>")
map("n", "Q", ":q<CR>")
map("n", "S", ":w <CR>")

-- fast home and end
map("", "<C-l>", "$")
map("", "<C-j>", "0")

-- insert moving
map("i", "<A-j>", "<Left>")
map("i", "<C-l>", "<End>")
map("i", "<A-l>", "<Right>")
map("i", "<A-i>", "<Up>")
map("i", "<A-k>", "<Down>")
map("i", "<C-j>", "<ESC>^i")

-- command
-- map("", ";", ":")

-- search move
map("", "-", "N")
map("", "=", "n")

--terminal
map("n", "tek", ":execute 15 .. 'new +terminal' | let b:term_type = 'hori' | startinsert <CR>")
map("n", "tel", ":execute 'vnew +terminal' | let b:term_type = 'vert' | startinsert <CR>")

-- indent
map("n", ">", ">>")
map("n", "<", "<<")
map("v", ">", ">gv")
map("v", "<", "<gv")

-- move line
map("v", "<A-k>", ":m '>+1<CR>gv-gv")
map("v", "<A-i>", ":m '<-2<CR>gv-gv")
map("n", "<A-k>", ":m .+1<CR>==")
map("n", "<A-i>", ":m .-2<CR>==")

-- Resize the arrows
map("n", "<Up>", ":resize -5<CR>")
map("n", "<Down>", ":resize +5<CR>")
map("n", "<Left>", ":vertical resize -5<CR>")
map("n", "<Right>", ":vertical resize +5<CR>")

-- move up/down the view port without moving the cursor
map("n", "<C-Y>", "5<C-y>")
map("n", "<C-E>", "5<C-e>")

-- use ESC to turn off search highlighting
map("n", "<Esc>", ":noh <CR>")

-- split window
-- map("n", "s", "<nop>")
-- map("n", "sl", ":set splitright<CR>:vsplit<CR>")
-- map("n", "sk", ":set splitbelow<CR>:split<CR>")
-- map("n", "sj", ":set nosplitright<CR>:vsplit<CR>:set splitright<CR>")
-- map("n", "si", ":set nosplitbelow<CR>:split<CR>:set splitbelow<CR>")

-- file path
map("n", "\\p", ":echo expand('%:p')<CR>")
-- <++>
map("n", "<LEADER><LEADER>", "<Esc>/<++><CR>:nohlsearch<CR>c4l")
-- figlet
map("n", "tx", ":r !figlet ")

-------------plugins mappings---------------
-- rnvimr
map("n", "R", ":RnvimrToggle<CR><C-\\><C-n>:RnvimrResize 0<CR>")
--goyo
map("n", "gy", ":Goyo<CR>")
-- swith true and false
map("n", "gw", ":Antovim<CR>")
-- undotree
map("n", "U", ":UndotreeToggle<CR>")
-- bufferline
map("n", "tl", ":BufferNext<CR>")
map("n", "tj", ":BufferPrevious<CR>")
-- this will change the action of <C-i>, cause TAB=<C-i>
-- map("n", "<TAB>", ":BufferNext<CR>")
map("n", "<S-TAB>", ":BufferPrevious<CR>")
-- lightspeed
-- map({"n", "v"}, "<LEADER>s", "<Plug>Lightspeed_s", { noremap=false })
map({ "n", "v" }, "<LEADER>S", "<Plug>Lightspeed_S", { noremap = false })
-- comment
map({ "n", "v" }, "<LEADER>c", ":CommentToggle <CR>")
-- nvimtree
map("n", "<C-n>", ":NvimTreeToggle <CR>")

-- others keymapping in which-key setting

-- Add Packer commands because we are not loading it at startup
local cmd = vim.cmd
cmd("silent! command PackerClean lua require 'plugins' require('packer').clean()")
cmd("silent! command PackerCompile lua require 'plugins' require('packer').compile()")
cmd("silent! command PackerInstall lua require 'plugins' require('packer').install()")
cmd("silent! command PackerStatus lua require 'plugins' require('packer').status()")
cmd("silent! command PackerSync lua require 'plugins' require('packer').sync()")
cmd("silent! command PackerUpdate lua require 'plugins' require('packer').update()")
