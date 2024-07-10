return {
	{
		"rebelot/heirline.nvim",
		event = "BufRead",
		config = function()
			require("plugins.configs.heirline")
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VimEnter",
		config = function()
			require("lq.configs.others").blankline()
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function()
			require("lq.configs.gitsigns")
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("lq.configs.others").autopairs()
		end,
	},

	{
		"folke/which-key.nvim",
		event = "VimEnter",
		config = function()
			require("lq.configs.which-key").setup()
		end,
	},

	-- Terminal
	{
		"akinsho/toggleterm.nvim",
		event = "VeryLazy",
		config = function()
			require("lq.configs.terminal").setup()
		end,
	},

	-- swith true false
	{
		"Laughing-q/antovim",
		cmd = { "Antovim" },
	},

	{
		"norcalli/nvim-colorizer.lua",
		cmd = "ColorizerToggle",
		config = function()
			require("lq.configs.others").colorizer()
		end,
	},

	-- undotree
	{
		"Laughing-q/undotree",
		cmd = "UndotreeToggle",
	},

	-- faster select
	{
		"sustech-data/wildfire.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = true,
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = true,
	},

	{
		"dstein64/nvim-scrollview",
		commit = "c076ebeb7227589d4cb54bc65e7d30c2d036f38c",
		event = "VeryLazy",
		config = function()
			require("lq.configs.others").scrollview()
		end,
	},

	{
		"lambdalisue/suda.vim",
		cmd = { "SudaWrite", "SudaRead" },
	},
	{
		"ThePrimeagen/vim-be-good",
		cmd = { "VimBeGood" },
	},

	{
		"ThePrimeagen/harpoon",
		event = "VimEnter",
		config = function()
			require("lq.configs.others").harpoon()
		end,
	},

	{
		"danymat/neogen",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = true,
		cmd = { "Neogen" },
	},
	{
		"Laughing-q/lf.nvim",
		cmd = { "Lf" },
		config = function()
			require("lf").setup({
				escape_quit = false,
				default_cmd = "lfimg",
			})
		end,
		requires = { "toggleterm.nvim" },
	},
}
