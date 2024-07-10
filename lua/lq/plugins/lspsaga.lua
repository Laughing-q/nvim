return {
	{
		"nvimdev/lspsaga.nvim",
		event = "VeryLazy",
		config = function()
			require("lspsaga").setup({
				callhierarchy = {
					layout = "float",
					keys = {
						edit = "<CR>",
						vsplit = "<C-v>",
						split = "<C-x>",
						shuttle = "[w",
						toggle_or_req = { "l", "<CR>" },
						close = "<C-c>k",
						tabe = "t",
						quit = "q",
					},
				},
				finder = {
					max_height = 0.7,
					left_width = 0.3,
					layout = "float",
					keys = {
						shuttle = "[w",
						toggle_or_open = { "l", "<CR>" },
						vsplit = "<C-v>",
						split = "<C-x>",
						close = "<C-c>k",
						tabe = "t",
						quit = "q",
					},
				},
				lightbulb = {
					enable = false,
				},
				outline = {
					layout = "normal",
					win_position = "left",
					win_width = 30,
					auto_preview = false,
					detail = false,
					auto_close = true,
					close_after_jump = false,
					-- for float window
					max_height = 0.5,
					left_width = 0.3,
					keys = {
						toggle_or_jump = "l",
						quit = "q",
						jump = "<CR>",
					},
				},
			})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},
}
