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
		event = "VeryLazy",
		config = function()
			require("plugins.configs.gitsigns")
		end,
	},

	-- lsp stuff
	{
		"neovim/nvim-lspconfig",
		enabled = status.lspconfig,
		dependencies = { "mason.nvim" },
		event = "VeryLazy",
		config = function()
			require("plugins.configs.lsp.lspconfig")
			vim.cmd("silent! do FileType")
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

	-- load luasnips + cmp related in insert mode only
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
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

	{
		"numToStr/Comment.nvim",
		enabled = status.comment,
		event = "BufWinEnter",
		config = function()
			others.comment()
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		enabled = status.telescope,
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
      {
        "nvim-tree/nvim-web-devicons"
      }
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
		"sustech-data/wildfire.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("wildfire").setup()
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup()
		end,
	},

	-- markdown
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install",
		enabled = status.markdown_preview,
		ft = { "markdown" },
	},
	{
		"dhruvasagar/vim-table-mode",
		enabled = status.table_mode,
		-- event = "BufRead",
		ft = { "markdown" },
		config = function()
			require("plugins.configs.markdown").table_mode()
		end,
	},
	{
		"mzlogin/vim-markdown-toc",
		enabled = status.markdown_toc,
		-- event = "BufRead",
		ft = { "markdown" },
		config = function()
			require("plugins.configs.markdown").markdown_toc()
		end,
	},
	{
		"dkarter/bullets.vim",
		enabled = status.bullets,
		ft = { "markdown" },
		-- event = "BufRead",
		config = function()
			require("plugins.configs.markdown").bullets()
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

	-- scrolling
	{
		"dstein64/nvim-scrollview",
		commit = "c076ebeb7227589d4cb54bc65e7d30c2d036f38c",
		enabled = status.scrollview,
		event = "BufRead",
		config = function()
			others.scrollview()
		end,
	},

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
		enabled = status.lf,
		cmd = { "Lf" },
		config = function()
			require("lf").setup({
				escape_quit = false,
				default_cmd = "lfimg",
			})
		end,
		requires = { "toggleterm.nvim" },
	},
	{
		"nvimdev/lspsaga.nvim",
		event = "VeryLazy",
		config = function()
			require("plugins.configs.lspsaga")
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},
}, {
	defaults = { lazy = true },
})
