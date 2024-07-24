local M = {}
require("lq.configs.compile")
require("lq.configs.format")
local leader_key = {}

leader_key = {
	setup = {
		plugins = {
			marks = true, -- shows a list of your marks on ' and `
			registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
			-- the presets plugin, adds help for a bunch of default keybindings in Neovim
			-- No actual key bindings are created
			presets = {
				operators = false, -- adds help for operators like d, y, ...
				motions = false, -- adds help for motions
				text_objects = false, -- help for text objects triggered after entering an operator
				windows = true, -- default bindings on <c-w>
				nav = true, -- misc bindings to work with windows
				z = true, -- bindings for folds, spelling and others prefixed with z
				g = true, -- bindings for prefixed with g
			},
			spelling = { enabled = true, suggestions = 20 }, -- use which-key for spelling hints
		},
		layout = {
			height = { min = 4, max = 25 }, -- min and max height of the columns
			width = { min = 20, max = 50 }, -- min and max width of the columns
			spacing = 3, -- spacing between columns
		},
		show_help = true, -- show help message on the command line when the popup is visible
	},

	opts = {
		mode = "n", -- NORMAL mode
		prefix = "<leader>",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymaps
		nowait = true, -- use `nowait` when creating keymaps
	},
	-- NOTE: Prefer using : over <cmd> as the latter avoids going back in normal-mode.
	-- see https://neovim.io/doc/user/map.html#:map-cmd

	mappings = {
		{ "<leader>l", group = "LSP", nowait = true, remap = false },
		{ "<leader>lL", "<cmd>LspStart<cr>", desc = "Open LSP", nowait = true, remap = false },
		{
			"<leader>lS",
			"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
			desc = "Workspace Symbols",
			nowait = true,
			remap = false,
		},
		{ "<leader>la", vim.lsp.buf.code_action, desc = "Code Action", nowait = true, remap = false },
		{ "<leader>lc", ":Lspsaga incoming_calls<CR>", desc = "Incoming Calls", nowait = true, remap = false },
		{
			"<leader>ld",
			"<cmd>Telescope diagnostics bufnr=0<cr>",
			desc = "Document Diagnostics",
			nowait = true,
			remap = false,
		},
		{ "<leader>lf", "<cmd>call Format()<CR>zz", desc = "Format", nowait = true, remap = false },
		{ "<leader>lh", "<cmd>LspInfo<cr>", desc = "Info", nowait = true, remap = false },
		{ "<leader>ll", "<cmd>LspStop<cr>", desc = "Close LSP", nowait = true, remap = false },
		{ "<leader>lq", vim.diagnostic.setloclist, desc = "Quickfix", nowait = true, remap = false },
		{ "<leader>lr", vim.lsp.buf.rename, desc = "Rename", nowait = true, remap = false },
		{
			"<leader>ls",
			"<cmd>Telescope lsp_document_symbols<cr>",
			desc = "Document Symbols",
			nowait = true,
			remap = false,
		},

		-- fold
		{ "<leader>o", "za", desc = "Fold", nowait = true, remap = false },
		-- Compile file
		{ "<leader>r", "<cmd>call CompileRunGcc()<CR>", desc = "Compile file", nowait = true, remap = false },
		-- functions and values
		{ "<leader>v", "<cmd>Lspsaga outline<CR>", desc = "Lspsaga outline", nowait = true, remap = false },
	},
}

M.setup = function()
	local which_key = require("which-key")
	which_key.setup(leader_key.setup)
	local mappings = leader_key.mappings
	which_key.add(mappings)
end

return M
