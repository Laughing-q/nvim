return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		event = "VimEnter",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			local map = vim.keymap.set

			harpoon:setup()
			map("n", "<leader>a", function()
				harpoon:list():add()
			end)
			map("n", "<C-k>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			map("n", "<A-1>", function()
				harpoon:list():select(1)
			end)
			map("n", "<A-2>", function()
				harpoon:list():select(2)
			end)
			map("n", "<A-3>", function()
				harpoon:list():select(3)
			end)
			map("n", "<A-4>", function()
				harpoon:list():select(4)
			end)

			map("n", "<A-j>", function()
				harpoon:list():prev()
			end)
			map("n", "<A-l>", function()
				harpoon:list():next()
			end)
		end,
	},
}
