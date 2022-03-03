local map = require("utils").map
local M = {}

M.misc = function()
	vim.g.mapleader = " " --leader
	-------------base mappings---------------
	-- Remap for dealing with word wrap
	-- map("", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
	-- map("", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

	map("", "K", "5k")
	map("", "J", "5j")
	map("", "H", "5h")
	map("", "L", "5l")
	map("", "I", "I")

	-- enter, quit and save
	map("n", "O", "o<ESC>")
	map("n", "Q", ":q<CR>")
	map("n", "S", ":w <CR>")

	-- fast home and end
  -- TODO: <C-h> may conflict with <backspace>
	map("", "<C-l>", "$")
	map("", "<C-h>", "0")

	-- insert moving
  -- TODO: <C-h> may conflict with <backspace>
	map("i", "<A-h>", "<Left>")
	map("i", "<C-l>", "<End>")
	map("i", "<A-l>", "<Right>")
	map("i", "<A-k>", "<Up>")
	map("i", "<A-j>", "<Down>")
	map("i", "<C-h>", "<ESC>^i")

	-- command
	-- map("", ";", ":")

	--terminal
	map("n", "tej", ":execute 10 .. 'new +terminal' | let b:term_type = 'hori' | startinsert <CR>")
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
	map("v", "<A-j>", ":m '>+1<CR>gv-gv")
	map("v", "<A-k>", ":m '<-2<CR>gv-gv")
	map("n", "<A-j>", ":m .+1<CR>==")
	map("n", "<A-k>", ":m .-2<CR>==")

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
	map("n", "\\w", ":pwd<CR>")
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

	-- lightspeed
	-- map({"n", "v"}, "<LEADER>s", "<Plug>Lightspeed_s", { noremap=false })
	map({ "n", "v" }, "<LEADER>S", "<Plug>Lightspeed_S", { noremap = false })

	-- comment
	-- map({ "n", "v" }, "<LEADER>c", ":CommentToggle <CR>")
	map("n", "<LEADER>c", ":lua require('Comment.api').toggle_current_linewise()<CR>")
	map("v", "<LEADER>c", ":lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>")

	-- nvimtree
	map("n", "<C-n>", ":NvimTreeToggle <CR>")
	-- map("n", "<C-n>", ":SidebarNvimToggle <CR>")

	-- others keymapping in which-key setting
end

M.barbar = function()
	-- bufferline
	-- map("n", "tl", ":BufferNext<CR>")
	-- map("n", "tj", ":BufferPrevious<CR>")
	-- map("n", "tml", ":BufferMoveNext<CR>")
	-- map("n", "tmj", ":BufferMovePrevious<CR>")
	map("n", "<A-l>", ":BufferNext<CR>")
	map("n", "<A-h>", ":BufferPrevious<CR>")
	map("n", "<A-;>", ":BufferMoveNext<CR>")
	map("n", "<A-g>", ":BufferMovePrevious<CR>")
	-- map("n", "<A-p>", ":BufferPin<CR>")
	-- Goto buffer in position...
	map("n", "<A-1>", ":BufferGoto 1<CR>")
	map("n", "<A-2>", ":BufferGoto 2<CR>")
	map("n", "<A-3>", ":BufferGoto 3<CR>")
	map("n", "<A-4>", ":BufferGoto 4<CR>")
	map("n", "<A-5>", ":BufferGoto 5<CR>")
	map("n", "<A-6>", ":BufferGoto 6<CR>")
	map("n", "<A-7>", ":BufferGoto 7<CR>")
	map("n", "<A-8>", ":BufferGoto 8<CR>")
	map("n", "<A-9>", ":BufferGoto 9<CR>")
	map("n", "<A-0>", ":BufferLast<CR>")
	-- this will change the action of <C-i>, cause TAB=<C-i>
	-- map("n", "<TAB>", ":BufferNext<CR>")
	-- map("n", "<S-TAB>", ":BufferPrevious<CR>")

	----------this will slow down startup time------------
	-- local wk_status_ok, wk = pcall(require, "which-key")
	-- if not wk_status_ok then
	-- 	return
	-- end
	-- local mappings = {
	-- 	b = {
	-- 		name = "Buffers",
	-- 		g = { "<cmd>BufferPick<cr>", "Jump" },
	-- 		b = { "<cmd>b#<cr>", "Previous" },
	-- 		w = { "<cmd>BufferWipeout<cr>", "Wipeout" },
	-- 		j = { "<cmd>BufferCloseBuffersLeft<cr>", "Close all to the left" },
	-- 		l = {
	-- 			"<cmd>BufferCloseBuffersRight<cr>",
	-- 			"Close all to the right",
	-- 		},
	-- 		c = {
	-- 			"<cmd>BufferCloseAllButCurrent<cr>",
	-- 			"Close all but Current",
	-- 		},
	-- 		p = {
	-- 			"<cmd>BufferCloseAllButPinned<cr>",
	-- 			"Close all but Pinned",
	-- 		},
	-- 		d = {
	-- 			"<cmd>BufferOrderByDirectory<cr>",
	-- 			"Sort by directory",
	-- 		},
	-- 		L = {
	-- 			"<cmd>BufferOrderByLanguage<cr>",
	-- 			"Sort by language",
	-- 		},
	-- 	},
	-- }
	-- local opts = {
	-- 	mode = "n", -- NORMAL mode
	-- 	prefix = "<leader>",
	-- 	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	-- 	silent = true, -- use `silent` when creating keymaps
	-- 	noremap = true, -- use `noremap` when creating keymaps
	-- 	nowait = true, -- use `nowait` when creating keymaps
	-- }
	-- wk.register(mappings, opts)
end

M.bufferline = function()
	map("n", "<A-l>", ":BufferLineCycleNext<CR>")
	map("n", "<A-h>", ":BufferLineCyclePrev<CR>")
	map("n", "<A-;>", ":BufferLineMoveNext<CR>")
	map("n", "<A-g>", ":BufferLineMovePrev<CR>")
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
	map("n", "<leader>bh", ":BufferLineCloseLeft<CR>")
	map("n", "<leader>bg", ":BufferLinePick<CR>")
	map("n", "<leader>bd", ":BufferLineSortByDirectory<CR>")
	map("n", "<leader>bL", ":BufferLineSortByExtension<CR>")
	map("n", "<leader>bt", ":BufferLineSortByTabs<CR>")
	map("n", "<leader>bp", ":BufferLinePickClose<CR>")
	-- map("n", "<leader>bc", ":BufferLineCloseLeft<CR>:BufferLineCloseRight<CR>")
	map("n", "<leader>bc", ":BufferCloseAllButCurrent<CR>")
	map("n", "<leader>bw", ":BufferKill<CR>")
end

return M
