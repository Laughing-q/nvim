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
		icons = {
			breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
			separator = "➜", -- symbol used between a key and it's label
			group = "+", -- symbol prepended to a group
		},
		window = {
			border = "single", -- none, single, double, shadow
			position = "bottom", -- bottom, top
			margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
			padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		},
		layout = {
			height = { min = 4, max = 25 }, -- min and max height of the columns
			width = { min = 20, max = 50 }, -- min and max width of the columns
			spacing = 3, -- spacing between columns
		},
		hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
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
		-- f = { "<cmd>Telescope find_files<CR>", "Find File" },
		["<CR>"] = { "<cmd>nohlsearch<CR>", "No Highlight" },

		-- window move stuff
		-- w = { "<C-w>w", "Window previous" },

		-- spell and wrap stuff
		-- s = {
		-- name = "spell and wrap",
		-- s = { ":set spell!<CR>", "Spell check" },
		-- w = { ":set wrap!<CR>", "Set wrap" },
		-- l = { ":set splitright<CR>:vsplit<CR>", "Split left" },
		-- k = { ":set splitbelow<CR>:split<CR>", "Split down" },
		-- i = { ":set nosplitright<CR>:vsplit<CR>:set splitright<CR>", "Split up" },
		-- j = { ":set nosplitbelow<CR>:split<CR>:set splitbelow<CR>", "Split right" },
		-- },

		-- functions and values
		v = { "<cmd>Lspsaga outline<CR>", "Lspsaga outline" },
		-- Compile file
		r = { "<cmd>call CompileRunGcc()<CR>", "Compile file" },
		-- transparency
		-- t = { "<cmd>call TransparentToggle<CR>", "Compile file" },

		-- fold
		o = { "za", "Fold" },
		-- markdown
		m = {
			name = "Markdown",
			g = { "<cmd>GenTocGFM<CR>", "GenToc" },
			-- m = { "<cmd>TableModeToggle<CR>", "TableMode" },
		},

		l = {
			name = "LSP",
			l = { "<cmd>LspStop<cr>", "Close LSP" },
			L = { "<cmd>LspStart<cr>", "Open LSP" },
			a = { vim.lsp.buf.code_action, "Code Action" },
			d = {
				"<cmd>Telescope diagnostics bufnr=0<cr>",
				"Document Diagnostics",
			},
			-- f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format" },
			f = { "<cmd>call Format()<CR>", "Format" },
			-- f = { "<cmd>lua vim.lsp.buf.range_formatting()<cr>", "Format" },
			h = { "<cmd>LspInfo<cr>", "Info" },
			k = {
				vim.diagnostic.goto_next,
				"Next Diagnostic",
			},
			i = {
				vim.diagnostic.goto_prev,
				"Prev Diagnostic",
			},
			q = { vim.diagnostic.setloclist, "Quickfix" },
			r = { vim.lsp.buf.rename, "Rename" },
			s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
			S = {
				"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
				"Workspace Symbols",
			},
			c = { ":Lspsaga incoming_calls<CR>", "Incoming Calls" },
		},
		T = {
			name = "Treesitter",
			i = { ":TSConfigInfo<cr>", "Info" },
			h = { ":TSHighlightCapturesUnderCursor<cr>", "Highlight" },
			p = { ":TSPlaygroundToggle<cr>", "Playground" },
		},
	},
}

M.setup = function()
	local which_key = require("which-key")

	which_key.setup(leader_key.setup)

	local opts = leader_key.opts

	local mappings = leader_key.mappings

	which_key.register(mappings, opts)
end

return M
