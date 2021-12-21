local present, packer = pcall(require, "plugins.packerInit")

if not present then
	return false
end

local status = require("plugins.opts").status

local use = packer.use

return packer.startup(function()
	use({
		"wbthomason/packer.nvim",
		event = "VimEnter",
	})

	use({
		"nvim-lua/plenary.nvim",
    disable = not status.plenary,
	})

	-- faster startup time
	use({
		"nathom/filetype.nvim",
    disable = not status.filetype,
	})

	use({
		"lewis6991/impatient.nvim",
    disable = not status.impatient,
	})

	use({
		"kyazdani42/nvim-web-devicons",
		event = "BufRead",
    disable = not status.devicons,
	})

	use({
		"famiu/feline.nvim",
		-- after = "nvim-web-devicons",
    disable = not status.feline,
		config = function()
			require("plugins.configs.statusline.simplifyline")
		end,
	})

	use({
		"lukas-reineke/indent-blankline.nvim",
    disable = not status.blankline,
		event = "BufRead",
		config = function()
			require("plugins.configs.others").blankline()
		end,
	})

	use({
		"nvim-treesitter/nvim-treesitter",
    disable = not status.treesitter,
		event = "BufRead",
		config = function()
			require("plugins.configs.treesitter")
		end,
	})

	-- git stuff
	use({
		"lewis6991/gitsigns.nvim",
    disable = not status.gitsigns,
		opt = true,
		config = function()
			require("plugins.configs.gitsigns")
		end,
		setup = function()
			require("utils").packer_lazy_load("gitsigns.nvim")
		end,
	})

	-- lsp stuff
	use({
		"neovim/nvim-lspconfig",
    disable = not status.lspconfig,
		opt = true,
		setup = function()
			require("utils").packer_lazy_load("nvim-lspconfig")
			-- reload the current file so lsp actually starts for it
			vim.defer_fn(function()
				vim.cmd('if &ft == "packer" | echo "" | else | silent! e %')
			end, 0)
		end,
		config = function()
			require("plugins.configs.lsp.lspconfig").setup()
		end,
	})

  -- TODO lazy load both nvim-lsp-installer and nvim-lspconfig may casue same issue.
	use({
		"williamboman/nvim-lsp-installer",
    disable = not status.lspinstaller,
		opt = true,
		setup = function()
			require("utils").packer_lazy_load("nvim-lsp-installer")
		end,
		config = function()
			require("plugins.configs.lsp.lspinstaller").setup_lsp()
		end,
	})

	use({
		"jose-elias-alvarez/null-ls.nvim",
    disable = not status.null_ls,
		after = "nvim-lspconfig",
		config = function()
			require("plugins.configs.lsp.null-ls").setup()
		end,
	})

	use({
		"ray-x/lsp_signature.nvim",
    disable = not status.lsp_signature,
		after = "nvim-lspconfig",
		config = function()
			require("plugins.configs.others").signature()
		end,
	})

	use({
		-- "andymass/vim-matchup",
		"Laughing-q/vim-matchup",
    disable = not status.matchup,
		opt = true,
		setup = function()
			require("utils").packer_lazy_load("vim-matchup")
		end,
	})

	-- load luasnips + cmp related in insert mode only

	use({
		"rafamadriz/friendly-snippets",
    disable = not status.cmp,
		event = "InsertEnter",
	})

	use({
		"hrsh7th/nvim-cmp",
    disable = not status.cmp,
		after = "friendly-snippets",
		config = function()
			require("plugins.configs.cmp")
		end,
	})

	use({
		"L3MON4D3/LuaSnip",
    disable = not status.cmp,
		wants = "friendly-snippets",
		after = "nvim-cmp",
		config = function()
			require("plugins.configs.others").luasnip()
		end,
	})

	use({
		"saadparwaiz1/cmp_luasnip",
    disable = not status.cmp,
		after = "LuaSnip",
	})

	use({
		"hrsh7th/cmp-nvim-lua",
    disable = not status.cmp,
		after = "cmp_luasnip",
	})

	use({
		"hrsh7th/cmp-nvim-lsp",
    disable = not status.cmp,
		after = "cmp-nvim-lua",
	})

	use({
		"hrsh7th/cmp-buffer",
    disable = not status.cmp,
		after = "cmp-nvim-lsp",
	})

	use({
		"hrsh7th/cmp-path",
    disable = not status.cmp,
		after = "cmp-buffer",
	})
	-- misc plugins
	use({
		"windwp/nvim-autopairs",
    disable = not status.autopairs,
		after = "nvim-cmp",
		config = function()
			require("plugins.configs.others").autopairs()
		end,
	})

	-- dashboard
	use {
	  "glepnir/dashboard-nvim",
    disable = not status.dashboard,
	  config = require("plugins.configs.dashboard"),
	}

	use({
		"numToStr/Comment.nvim",
    disable = not status.comment,
		cmd = "Comment",
		config = function()
			require("plugins.configs.others").comment()
		end,
    setup = function()
      require("utils").packer_lazy_load("Comment.nvim")
    end,
	})

	-- file managing , picker etc
	use({
		"kyazdani42/nvim-tree.lua",
    disable = not status.nvimtree,
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		config = function()
			require("plugins.configs.nvimtree")
		end,
	})

	use({
		"nvim-telescope/telescope.nvim",
    disable = not status.telescope,
		module = "telescope",
		cmd = "Telescope",
		requires = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
        disable = not status.fzf,
				run = "make",
				opt = true,
				setup = function()
					require("utils").packer_lazy_load("telescope-fzf-native.nvim")
				end,
			},
			{
				"nvim-telescope/telescope-media-files.nvim",
				disable = not status.media,
			},
			{
				"ahmedkhalf/project.nvim",
				disable = not status.project,
				opt = true,
				config = function()
					require("plugins.configs.telescope_ex.project").setup()
				end,
				setup = function()
					require("utils").packer_lazy_load("project.nvim")
				end,
			},
			{
				"AckslD/nvim-neoclip.lua",
				requires = { "tami5/sqlite.lua", module = "sqlite" },
				disable = not status.neoclip,
				opt = true,
				setup = function()
					require("utils").packer_lazy_load("nvim-neoclip.lua")
				end,
				config = function()
					require("plugins.configs.telescope_ex.nvimclip").setup()
				end,
			},
		},
		config = function()
			require("plugins.configs.telescope")
		end,
	})

	-- keybinding
	use({
		"folke/which-key.nvim",
    disable = not status.which_key,
		event = "BufRead",
		config = function()
			require("plugins.configs.which-key").setup()
		end,
	})
	-- colorscheme
	use({
		"Laughing-q/tokyonight.nvim",
    disable = not status.tokyonight,
	})
	-- use {
	--    "xiyaowong/nvim-transparent",
	-- }

	-- bufferline
	use({
		"romgrk/barbar.nvim",
    disable = not status.barbar,
		event = "BufWinEnter",
		-- after = "nvim-web-devicons",
	})
	-- multi select
	use({
		"mg979/vim-visual-multi",
    disable = not status.visual_multi,
		event = "BufRead",
		-- opt = true,
		-- setup = function()
		--    require("utils").packer_lazy_load "vim-visual-multi"
		-- end,
	})

	-- rainbow parentheses
	-- use {
	--    "p00f/nvim-ts-rainbow",
	--    after = "nvim-treesitter",
	-- }

	-- Terminal
	use({
		"akinsho/toggleterm.nvim",
    disable = not status.terminal,
		event = "BufWinEnter",
		config = function()
			require("plugins.configs.terminal").setup()
		end,
	})
	-- swith true false
	use({
		"Laughing-q/antovim",
    disable = not status.antovim,
		cmd = { "Antovim" },
	})
	-- show color, `nvim-colorizer` is another option
	-- use {
	--    "RRethy/vim-hexokinase",
	--    run = "make hexokinase",
	--    opt = true,
	--    setup = function()
	--       require("utils").packer_lazy_load "vim-hexokinase"
	--    end,
	-- }
	use({
		"norcalli/nvim-colorizer.lua",
    disable = not status.colorizer,
		event = "BufRead",
		config = function()
			require("plugins.configs.others").colorizer()
		end,
	})

	-- undotree
	use({
		"Laughing-q/undotree",
    disable = not status.undotree,
		cmd = { "UndotreeToggle" },
	})
	-- functions and values
	use({
		"liuchengxu/vista.vim",
    disable = not status.vista,
		cmd = { "Vista" },
	})
	-- focus 1
	use({
		"junegunn/goyo.vim",
    disable = not status.goyo,
		cmd = { "Goyo" },
	})
	-- faster select
	use({
		"gcmt/wildfire.vim",
    disable = not status.wildfire,
		event = "BufRead",
		-- disable = true,
	})
	use({
		"tpope/vim-surround",
    disable = not status.surround,
		event = "BufRead",
		-- disable = true,
	})
	-- rnvimr
	use({
		"kevinhwang91/rnvimr",
    disable = not status.rnvimr,
		command = "RnvimrToggle",
		config = function()
			require("plugins.configs.others").rnvimr()
		end,
		opt = true,
		setup = function()
			require("utils").packer_lazy_load("rnvimr")
		end,
	})
	-- markdown
	use({
		"instant-markdown/vim-instant-markdown",
    disable = not status.instant_markdown,
		event = "BufRead",
		ft = { "markdown" },
		config = function()
			require("plugins.configs.markdown.instant_markdown").setup()
		end,
	})
	use({
		"dhruvasagar/vim-table-mode",
    disable = not status.table_mode,
		event = "BufRead",
		ft = { "markdown" },
		config = function()
			require("plugins.configs.markdown.table_mode").setup()
		end,
	})
	use({
		"mzlogin/vim-markdown-toc",
    disable = not status.markdown_toc,
		event = "BufRead",
		ft = { "markdown" },
		config = function()
			require("plugins.configs.markdown.markdown_toc").setup()
		end,
	})
	use({
		"dkarter/bullets.vim",
    disable = not status.bullets,
		event = "BufRead",
		ft = { "markdown" },
		config = function()
			require("plugins.configs.markdown.bullets").setup()
		end,
	})
  -- latex
	use({
		"lervag/vimtex",
    disable = not status.vimtex,
		ft = { "tex" },
		config = function()
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_compiler_progname = "xelatex"
			-- vim.g.vimtex_compiler_latexmk_engines='xelatex'
		end,
	})
	-- faster move, jump between characters
	use({
		"ggandor/lightspeed.nvim",
    disable = not status.lightspeed,
		event = "BufRead",
	})

	-- scrolling
	use({
		"dstein64/nvim-scrollview",
    disable = not status.scrollview,
		event = "BufRead",
	})

	-- scroll smoothly
	-- use {
	--   'karb94/neoscroll.nvim',
 --    disable=true,
 --    event = "BufRead",
 --    config = function ()
 --      require('neoscroll').setup()
 --    end
	-- }

	-- code hint from AI
	-- use {
	--   'github/copilot.vim'
	-- }

	-- notify
	use {
	  'rcarriga/nvim-notify',
		event = "BufRead",
    disable = not status.notify
	}

	-- use {
	--    "xuhdev/vim-latex-live-preview",
	-- }
end)
