return {
	{
		"rebelot/heirline.nvim",
		event = "BufRead",
		config = function()
			require("lq.configs.heirline")
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
		"lambdalisue/suda.vim",
		cmd = { "SudaWrite", "SudaRead" },
	},
	{
		"ThePrimeagen/vim-be-good",
		cmd = { "VimBeGood" },
	},

	{
		"danymat/neogen",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = true,
		cmd = { "Neogen" },
	},
}
