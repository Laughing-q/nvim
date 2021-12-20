local present, packer = pcall(require, "plugins.packerInit")

if not present then
	return false
end

local use = packer.use

return packer.startup(function()
	use({
		"nvim-lua/plenary.nvim",
	})

	use({
		"wbthomason/packer.nvim",
		event = "VimEnter",
	})

	use({
		"kyazdani42/nvim-web-devicons",
		event = "BufRead",
	})

	use({
		"famiu/feline.nvim",
		-- after = "nvim-web-devicons",
		config = function()
			require("plugins.configs.statusline.simplifyline")
		end,
	})

	use({
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		config = function()
			require("plugins.configs.others").blankline()
		end,
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		branch = "0.5-compat",
		event = "BufRead",
		config = function()
			require("plugins.configs.treesitter")
		end,
	})

	-- git stuff
	use({
		"lewis6991/gitsigns.nvim",
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

	use({
		"williamboman/nvim-lsp-installer",
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
		after = "nvim-lspconfig",
		config = function()
			require("plugins.configs.lsp.null-ls").setup()
		end,
	})

	use({
		"ray-x/lsp_signature.nvim",
		after = "nvim-lspconfig",
		config = function()
			require("plugins.configs.others").signature()
		end,
	})

	use({
		-- "andymass/vim-matchup",
		"Laughing-q/vim-matchup",
		opt = true,
		setup = function()
			require("utils").packer_lazy_load("vim-matchup")
		end,
	})

	-- load luasnips + cmp related in insert mode only

	use({
		"rafamadriz/friendly-snippets",
		event = "InsertEnter",
	})

	use({
		"hrsh7th/nvim-cmp",
		after = "friendly-snippets",
		config = function()
			require("plugins.configs.cmp")
		end,
	})

	use({
		"L3MON4D3/LuaSnip",
		wants = "friendly-snippets",
		after = "nvim-cmp",
		config = function()
			require("plugins.configs.others").luasnip()
		end,
	})

	use({
		"saadparwaiz1/cmp_luasnip",
		after = "LuaSnip",
	})

	use({
		"hrsh7th/cmp-nvim-lua",
		after = "cmp_luasnip",
	})

	use({
		"hrsh7th/cmp-nvim-lsp",
		after = "cmp-nvim-lua",
	})

	use({
		"hrsh7th/cmp-buffer",
		after = "cmp-nvim-lsp",
	})

	use({
		"hrsh7th/cmp-path",
		after = "cmp-buffer",
	})
	-- misc plugins
	use({
		"windwp/nvim-autopairs",
		after = "nvim-cmp",
		config = function()
			require("plugins.configs.others").autopairs()
		end,
	})

	-- dashboard
	-- use {
	--    "glepnir/dashboard-nvim",
	--    config = require("plugins.configs.dashboard"),
	-- }

	use({
		"numToStr/Comment.nvim",
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
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		config = function()
			require("plugins.configs.nvimtree")
		end,
	})

	use({
		"nvim-telescope/telescope.nvim",
		module = "telescope",
		cmd = "Telescope",
		requires = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				disable = false,
				run = "make",
				opt = true,
				setup = function()
					require("utils").packer_lazy_load("telescope-fzf-native.nvim")
				end,
			},
			{
				"nvim-telescope/telescope-media-files.nvim",
				disable = true,
			},
			{
				"ahmedkhalf/project.nvim",
				disable = false,
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
				disable = false,
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

	-- faster startup time
	use({
		"nathom/filetype.nvim",
	})

	use({
		"lewis6991/impatient.nvim",
	})
	-- keybinding
	use({
		"folke/which-key.nvim",
		event = "BufRead",
		config = function()
			require("plugins.configs.which-key").setup()
		end,
	})
	-- colorscheme
	use({
		"Laughing-q/tokyonight.nvim",
	})
	-- use {
	--    "xiyaowong/nvim-transparent",
	-- }

	-- bufferline
	use({
		"romgrk/barbar.nvim",
		event = "BufWinEnter",
		-- after = "nvim-web-devicons",
	})
	-- multi select
	use({
		"mg979/vim-visual-multi",
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
		event = "BufWinEnter",
		config = function()
			require("plugins.configs.terminal").setup()
		end,
	})
	-- swith true false
	use({
		"Laughing-q/antovim",
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
		event = "BufRead",
		config = function()
			require("plugins.configs.others").colorizer()
		end,
	})

	-- undotree
	use({
		"Laughing-q/undotree",
		cmd = { "UndotreeToggle" },
	})
	-- functions and values
	use({
		"liuchengxu/vista.vim",
		cmd = { "Vista" },
	})
	-- focus 1
	use({
		"junegunn/goyo.vim",
		cmd = { "Goyo" },
	})
	-- faster select
	use({
		"gcmt/wildfire.vim",
		event = "BufRead",
		-- disable = true,
	})
	use({
		"tpope/vim-surround",
		event = "BufRead",
		-- disable = true,
	})
	-- rnvimr
	use({
		"kevinhwang91/rnvimr",
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
		event = "BufRead",
		ft = { "markdown" },
		config = function()
			require("plugins.configs.markdown.instant_markdown").setup()
		end,
	})
	use({
		"dhruvasagar/vim-table-mode",
		event = "BufRead",
		ft = { "markdown" },
		config = function()
			require("plugins.configs.markdown.table_mode").setup()
		end,
	})
	use({
		"mzlogin/vim-markdown-toc",
		event = "BufRead",
		ft = { "markdown" },
		config = function()
			require("plugins.configs.markdown.markdown_toc").setup()
		end,
	})
	use({
		"dkarter/bullets.vim",
		event = "BufRead",
		ft = { "markdown" },
		config = function()
			require("plugins.configs.markdown.bullets").setup()
		end,
	})
	use({
		"lervag/vimtex",
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
		event = "BufRead",
	})

	-- scrolling
	use({
		"dstein64/nvim-scrollview",
		event = "BufRead",
	})

	-- scroll smoothly
	-- use {
	--   'karb94/neoscroll.nvim',
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
	-- use {
	--   'rcarriga/nvim-notify',
	-- }

	-- use {
	--    "xuhdev/vim-latex-live-preview",
	-- }
end)
