local map = require("utils").map
local M = {}

M.barbar = function()
	-- bufferline
	-- map("n", "tl", ":BufferNext<CR>")
	-- map("n", "tj", ":BufferPrevious<CR>")
	-- map("n", "tml", ":BufferMoveNext<CR>")
	-- map("n", "tmj", ":BufferMovePrevious<CR>")
	map("n", "<A-l>", ":BufferNext<CR>")
	map("n", "<A-j>", ":BufferPrevious<CR>")
	map("n", "<A-;>", ":BufferMoveNext<CR>")
	map("n", "<A-h>", ":BufferMovePrevious<CR>")
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
end
return M
