local map = require("utils").map
local M = {}

M.misc = function()
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

	-- map("", "I", "5k")
	-- map("", "K", "5j")
	-- map("", "J", "5h")
	-- map("", "L", "5l")
	map("", "I", "<nop>")
	map("", "K", "<nop>")
	map("", "J", "<nop>")
	map("", "L", "<nop>")
	map("", "H", "I")

	-- enter, quit and save
	map("n", "O", "o<ESC>")
	map("n", "Q", ":q<CR>")
	map("n", "S", ":w <CR>")

	-- fast home and end
	map("", "<C-l>", "$")
	map("", "<C-j>", "_")

	-- insert moving
	map("i", "<A-j>", "<Left>")
	map("i", "<C-l>", "<End>")
	map("i", "<A-l>", "<Right>")
	map("i", "<A-i>", "<Up>")
	map("i", "<A-k>", "<Down>")
	map("i", "<C-j>", "<ESC>^i")

	-- command
	-- map("", ";", ":")

	--terminal
	map("n", "tek", ":execute 16 .. 'new +terminal' | let b:term_type = 'hori' | startinsert <CR>")
	map("n", "tel", ":execute 'vnew +terminal' | let b:term_type = 'vert' | startinsert <CR>")
	map("t", "JK", "<C-\\><C-n><C-w>w")
	-- map("n", "jk", "<C-w>wa")
	-- map("t", "JK", "<C-\\><C-n> :lua require('utils').close_buffer() <CR>")

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
	map("n", "<Up>", ":resize -1<CR>")
	map("n", "<Down>", ":resize +1<CR>")
	map("n", "<Left>", ":vertical resize -1<CR>")
	map("n", "<Right>", ":vertical resize +1<CR>")

	-- move up/down the view port without moving the cursor
	map("n", "<C-Y>", "5<C-y>")
	map("n", "<C-E>", "5<C-e>")
	map("n", "<C-D>", "<C-D>zz")
	map("n", "<C-U>", "<C-U>zz")
	map("n", "n", "nzz")
	map("n", "N", "Nzz")

	-- use ESC to turn off search highlighting
	map("n", "<Esc>", ":noh <CR>")

	-- split window
	map("n", "s", "<nop>")
	map("n", "sl", ":set splitright<CR>:vsplit<CR>")
	map("n", "sk", ":set splitbelow<CR>:split<CR>")
	map("n", "sj", ":set nosplitright<CR>:vsplit<CR>:set splitright<CR>")
	map("n", "si", ":set nosplitbelow<CR>:split<CR>:set splitbelow<CR>")

	-- spell and warp
	map("n", "sw", ":set wrap!<CR>")
	map("n", "ss", ":set spell!<CR>")

	-- file path
	map("n", "\\p", ":echo expand('%:p')<CR>")
	map("n", "\\w", ":pwd<CR>")
	-- <++>
	map("n", "<LEADER><LEADER>", "<Esc>/<++><CR>:nohlsearch<CR>c4l")
	-- figlet
	map("n", "tx", ":r !figlet ")

  map("x", "<leader>p", "\"_dP")

	-------------plugins mappings---------------
	-- rnvimr
	map("n", "R", ":RnvimrToggle<CR><C-\\><C-n>:RnvimrResize 0<CR>")

	--goyo
	map("n", "gy", ":Goyo<CR>")

	-- swith true and false
	map("n", "gw", ":Antovim<CR>")

	-- undotree
	map("n", "U", ":UndotreeToggle<CR>")

	-- lightspeed
	map({ "n", "v" }, "K", "<Plug>Lightspeed_s", { noremap = false, desc = "jump down" })
	map({ "n", "v" }, "I", "<Plug>Lightspeed_S", { noremap = false, desc = "jump up" })

	-- nvimtree
	map("n", "<C-n>", ":NvimTreeToggle <CR>")

	-- others keymapping in which-key setting
end


M.bufferline = function()
	map("n", "<A-l>", ":BufferLineCycleNext<CR>")
	map("n", "<A-j>", ":BufferLineCyclePrev<CR>")
	map("n", "<A-;>", ":BufferLineMoveNext<CR>")
	map("n", "<A-h>", ":BufferLineMovePrev<CR>")
	map("n", "<A-1>", ":BufferLineGoToBuffer 1<CR>")
	map("n", "<A-2>", ":BufferLineGoToBuffer 2<CR>")
	map("n", "<A-3>", ":BufferLineGoToBuffer 3<CR>")
	map("n", "<A-4>", ":BufferLineGoToBuffer 4<CR>")
	map("n", "<A-5>", ":BufferLineGoToBuffer 5<CR>")
	map("n", "<A-6>", ":BufferLineGoToBuffer 6<CR>")
	map("n", "<A-7>", ":BufferLineGoToBuffer 7<CR>")
	map("n", "<A-8>", ":BufferLineGoToBuffer 8<CR>")
	map("n", "<A-9>", ":BufferLineGoToBuffer 9<CR>")

	map("n", "<leader>bl", ":BufferLineCloseRight<CR>")
	map("n", "<leader>bj", ":BufferLineCloseLeft<CR>")
	map("n", "<leader>bg", ":BufferLinePick<CR>")
	map("n", "<leader>bd", ":BufferLineSortByDirectory<CR>")
	map("n", "<leader>bL", ":BufferLineSortByExtension<CR>")
	map("n", "<leader>bt", ":BufferLineSortByTabs<CR>")
	map("n", "<leader>bp", ":BufferLineTogglePin<CR>")
	-- map("n", "<leader>bp", ":BufferLinePickClose<CR>")
	-- map("n", "<leader>bc", ":BufferLineCloseLeft<CR>:BufferLineCloseRight<CR>")
	map("n", "<leader>bc", ":BufferCloseAllButCurrent<CR>")
	map("n", "<leader>bw", ":BufferKill<CR>")
end

return M
