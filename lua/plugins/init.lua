local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local status = require("plugins.opts").status
local others = require("plugins.configs.others")

require("lazy").setup({
	{
		"nvim-lua/plenary.nvim",
		enabled = status.plenary,
	},

	-- faster startup time
	{
		"nathom/filetype.nvim",
		enabled = status.filetype,
	},

	{
		"kyazdani42/nvim-web-devicons",
		event = "BufRead",
		enabled = status.devicons,
	},

	-- statueline
	{
		"feline-nvim/feline.nvim",
		event = "BufRead",
		enabled = status.feline,
		config = function()
			require("plugins.configs.feline")
		end,
	},

	{
		"rebelot/heirline.nvim",
		event = "BufRead",
		enabled = status.heirline,
		config = function()
			require("plugins.configs.heirline")
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		enabled = status.blankline,
		event = "BufRead",
		config = function()
			others.blankline()
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		enabled = status.treesitter,
		event = "BufRead",
		config = function()
			require("plugins.configs.treesitter")
		end,
	},

	{ -- Additional text objects via treesitter
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter" },
		enabled = status.treesitter,
		event = "BufRead",
	},

	-- git stuff
	{
		"lewis6991/gitsigns.nvim",
		enabled = status.gitsigns,
		-- event = "BufRead",
		config = function()
			require("plugins.configs.gitsigns")
		end,
		init = function()
			require("utils").lazy_load("gitsigns.nvim")
		end,
	},

	-- lsp stuff
	{
		"neovim/nvim-lspconfig",
		enabled = status.lspconfig,
		dependencies = { "mason.nvim" },
		-- event = "BufWinEnter",
		config = function()
			require("plugins.configs.lsp.lspconfig")
		end,
		init = function()
			require("utils").lazy_load("nvim-lspconfig")
		end,
	},

	{
		"williamboman/mason.nvim",
		enabled = status.lspinstaller,
		build = ":MasonUpdate",
		config = function()
			require("plugins.configs.lsp.mason")
		end,
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
		enabled = status.null_ls,
		dependencies = "nvim-lspconfig",
		config = function()
			require("plugins.configs.lsp.null-ls").setup()
		end,
	},

	-- TODO: remove it or config it
	-- {
	-- 	-- "andymass/vim-matchup",
	-- 	"Laughing-q/vim-matchup",
	-- 	enabled = status.matchup,
	-- },

	-- load luasnips + cmp related in insert mode only

	{
		"hrsh7th/nvim-cmp",
		enabled = status.cmp,
		config = function()
			require("plugins.configs.cmp")
		end,
		dependencies = {
			{
				-- snippet plugin
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
				config = function()
					others.luasnip()
				end,
			},

			-- cmp sources plugins
			{
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
			},
		},
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			others.autopairs()
		end,
		dependencies = "hrsh7th/nvim-cmp",
	},

	-- dashboard
	{
		"glepnir/dashboard-nvim",
		enabled = status.dashboard,
		config = function()
			require("plugins.configs.dashboard")
		end,
	},

	{
		"numToStr/Comment.nvim",
		enabled = status.comment,
		event = "BufWinEnter",
		config = function()
			others.comment()
		end,
	},

	-- file managing , picker etc
	{
		"kyazdani42/nvim-tree.lua",
		enabled = status.nvimtree,
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		config = function()
			require("plugins.configs.nvimtree")
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		enabled = status.telescope,
		-- lazy = false,
		-- cmd = "Telescope",
		event = "BufRead",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				enabled = status.fzf,
				build = "make",
			},
			{
				"ahmedkhalf/project.nvim",
				enabled = status.project,
				config = function()
					require("plugins.configs.telescope_ex.project").setup()
				end,
			},
		},
		config = function()
			require("plugins.configs.telescope")
		end,
	},

	-- keybinding
	{
		"folke/which-key.nvim",
		enabled = status.which_key,
		event = "BufRead",
		config = function()
			require("plugins.configs.which-key").setup()
		end,
	},
	-- colorscheme
	{
		"folke/tokyonight.nvim",
		enabled = status.tokyonight,
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
	},
	{
		"rebelot/kanagawa.nvim",
		enabled = status.kanagawa,
	},

	-- bufferline
	{
		"akinsho/bufferline.nvim",
		enabled = status.bufferline,
		event = "BufWinEnter",
		config = function()
			require("plugins.configs.bufferline").setup()
		end,
		-- setup = function()
		-- 	require("keymappings").bufferline()
		-- end,
	},

	-- Terminal
	{
		"akinsho/toggleterm.nvim",
		enabled = status.terminal,
		event = "BufWinEnter",
		config = function()
			require("plugins.configs.terminal").setup()
		end,
	},

	-- swith true false
	{
		"Laughing-q/antovim",
		enabled = status.antovim,
		cmd = { "Antovim" },
	},

	{
		"norcalli/nvim-colorizer.lua",
		enabled = status.colorizer,
		event = "BufRead",
		config = function()
			others.colorizer()
		end,
	},

	-- undotree
	{
		"Laughing-q/undotree",
		enabled = status.undotree,
		cmd = { "UndotreeToggle" },
	},
	-- functions and values
	--
	{
		"stevearc/aerial.nvim",
		enabled = status.aerial,
		cmd = { "AerialToggle" },
		config = function()
			-- require('aerial').setup({})
			require("plugins.configs.aerial")
		end,
	},

	-- faster select
	{
		"gcmt/wildfire.vim",
		enabled = status.wildfire,
		event = "BufRead",
		-- disable = true,
	},
	{
		"tpope/vim-surround",
		enabled = status.surround,
		event = "BufRead",
		-- disable = true,
	},
	-- rnvimr
	{
		"kevinhwang91/rnvimr",
		enabled = status.rnvimr,
		cmd = "RnvimrToggle",
		config = function()
			others.rnvimr()
		end,
	},
	-- markdown
	{
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		enabled = status.markdown_preview,
		-- event = "BufRead",
		ft = { "markdown" },
	},
	{
		"dhruvasagar/vim-table-mode",
		enabled = status.table_mode,
		-- event = "BufRead",
		ft = { "markdown" },
		config = function()
			require("plugins.configs.markdown.table_mode").setup()
		end,
	},
	{
		"mzlogin/vim-markdown-toc",
		enabled = status.markdown_toc,
		-- event = "BufRead",
		ft = { "markdown" },
		config = function()
			require("plugins.configs.markdown.markdown_toc").setup()
		end,
	},
	{
		"dkarter/bullets.vim",
		enabled = status.bullets,
		ft = { "markdown" },
		-- event = "BufRead",
		config = function()
			require("plugins.configs.markdown.bullets").setup()
		end,
	},
	-- latex
	{
		"lervag/vimtex",
		enabled = status.vimtex,
		ft = { "tex" },
		config = function()
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_compiler_progname = "xelatex"
			-- vim.g.vimtex_compiler_latexmk_engines='xelatex'
		end,
	},

	-- faster move, jump between characters
	{
		"folke/flash.nvim",
		enabled = status.flash,
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			-- {
			-- 	"s",
			-- 	mode = { "n", "o", "x" },
			-- 	function()
			-- 		require("flash").treesitter()
			-- 	end,
			-- 	desc = "Flash Treesitter",
			-- },
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
		},
	},

	-- scrolling
	{
		"dstein64/nvim-scrollview",
		enabled = status.scrollview,
		event = "BufRead",
		config = function()
			others.scrollview()
		end,
	},

	-- debug
	{
		"mfussenegger/nvim-dap",
		event = "BufRead",
		enabled = status.dap,
	},

	-- use {
	--    "xuhdev/vim-latex-live-preview",
	-- }

	-- remote, rarely used it
	-- {
	-- 	"chipsenkbeil/distant.nvim",
	-- 	cmd = "DistantLaunch",
	-- 	-- DistantLaunch ip mode=ssh ssh.user=username
	-- 	config = function()
	-- 		require("distant").setup({
	-- 			-- Applies Chip's personal settings to every machine you connect to
	-- 			--
	-- 			-- 1. Ensures that distant servers terminate with no connections
	-- 			-- 2. Provides navigation bindings for remote directories
	-- 			-- 3. Provides keybinding to jump into a remote file's parent directory
	-- 			["*"] = require("distant.settings").chip_default(),
	-- 		})
	-- 	end,
	-- })

	{
		"lambdalisue/suda.vim",
		cmd = { "SudaWrite", "SudaRead" },
		enabled = status.suda,
	},
	{
		"ThePrimeagen/vim-be-good",
		cmd = { "VimBeGood" },
	},

	{
		"ThePrimeagen/harpoon",
		event = "BufRead",
		config = function()
			require("keymappings").harpoon()
		end,
	},

	{
		"danymat/neogen",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = true,
		cmd = { "Neogen" },
		-- Uncomment next line if you want to follow only stable versions
		-- version = "*"
	},
	{
		"Laughing-q/lf.nvim",
    cmd = {"Lf"},
		config = function()
			-- This feature will not work if the plugin is lazy-loaded
			vim.g.lf_netrw = 1

			require("lf").setup({
				escape_quit = false,
				border = "rounded",
        default_cmd = "lfimg",
			})

			vim.api.nvim_create_autocmd({
				event = "User",
				pattern = "LfTermEnter",
				callback = function(a)
					vim.api.nvim_buf_set_keymap(a.buf, "t", "q", "q", { nowait = true })
				end,
			})
		end,
		requires = { "toggleterm.nvim" },
	},
}, {
	defaults = { lazy = true },
})
