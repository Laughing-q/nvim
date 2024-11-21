local map = vim.keymap.set

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

map("", "H", "I")

-- enter, quit and save
map("n", "O", "o<ESC>")
map("n", "Q", ":q<CR>")
map("n", "S", ":w <CR>")

-- fast home and end
map("n", "<C-l>", "$")
-- ignore the return sign
map("v", "<C-l>", "$h")
map("", "<C-j>", "_")

-- insert moving
map("i", "<A-j>", "<Left>")
map("i", "<C-l>", "<End>")
map("i", "<A-l>", "<Right>")
map("i", "<A-i>", "<Up>")
map("i", "<A-k>", "<Down>")
map("i", "<C-j>", "<ESC>^i")

--terminal
map("n", "tek", ":execute 16 .. 'new +terminal' | let b:term_type = 'hori' | startinsert <CR>")
map("n", "tel", ":execute 'vnew +terminal' | let b:term_type = 'vert' | startinsert <CR>")
map("t", "JK", "<C-\\><C-n><C-w>w")

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
map("n", "<C-Y>", "5<C-y>") -- rarely used
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

-- window jump
map("n", "J", "<C-w>h")
map("n", "L", "<C-w>l")
map("n", "I", "<C-w>k")
map("n", "K", "<C-w>j")

-- spell and warp
map("n", "sw", ":set wrap!<CR>")
map("n", "ss", ":set spell!<CR>")

-- file path(rarely used)
map("n", "\\p", ":echo expand('%:p')<CR>")
map("n", "\\w", ":pwd<CR>")

-- <++>
map("n", "<LEADER><LEADER>", '<Esc>/<++><CR>:nohlsearch<CR>"_c4l')

map("x", "<leader>p", '"_dP')

-- location list
map("n", "[t", "<cmd>lprev<CR>zz")
map("n", "]t", "<cmd>lnext<CR>zz")

-- comment
map("n", "<LEADER>c", "gcc", { remap = true })
map("v", "<LEADER>c", "gc", { remap = true })

-- mark
map("n", "M", "`")

-- personal test file
map("n", "g1", "<cmd>e /home/laughing/codes/ultralytics/runs/1.py<CR>zz")

-------------plugins mappings---------------
map("n", "R", ":Lf<CR>")

-- tmux
map("n", "<C-G>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- swith true and false
map("n", "gw", ":Antovim<CR>")

-- undotree
map("n", "U", ":UndotreeToggle<CR>")

-- lspsaga
map("n", "gr", ":Lspsaga finder<CR>")
-- map("n", "gD", ":Lspsaga peek_definition<CR>")
map("n", "gD", ":vsplit<CR>:lua vim.lsp.buf.definition()<CR>")

-- copliot
map(
	{ "v", "n" },
	"<leader>ke",
	"<cmd>CopilotChatExplain<CR>",
	{ desc = "CopilotExplain", nowait = true, remap = false }
)
map({ "v", "n" }, "<leader>kr", "<cmd>CopilotChatReview<CR>", { desc = "CopilotReview", nowait = true, remap = false })
map({ "v", "n" }, "<leader>kf", "<cmd>CopilotChatFix<CR>", { desc = "CopilotFix", nowait = true, remap = false })
map(
	{ "v", "n" },
	"<leader>ko",
	"<cmd>CopilotChatOptimize<CR>",
	{ desc = "CopilotOptimize", nowait = true, remap = false }
)
map({ "v", "n" }, "<leader>kd", "<cmd>CopilotChatDocs<CR>", { desc = "CopilotDocs", nowait = true, remap = false })
map({ "v", "n" }, "<leader>kt", "<cmd>CopilotChatTests<CR>", { desc = "CopilotTests", nowait = true, remap = false })
map(
	{ "v", "n" },
	"<leader>kc",
	"<cmd>CopilotChatCommit<CR>",
	{ desc = "CopilotCommitInfo", nowait = true, remap = false }
)
