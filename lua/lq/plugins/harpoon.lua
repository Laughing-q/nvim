return {
	{
		"ThePrimeagen/harpoon",
		event = "VimEnter",
		config = function()
			local mark = require("harpoon.mark")
			local ui = require("harpoon.ui")
			local map = vim.keymap.set
			map("n", "<leader>a", mark.add_file)
			map("n", "<C-k>", ui.toggle_quick_menu)

			map("n", "<A-l>", function()
				ui.nav_next()
			end)
			map("n", "<A-j>", function()
				ui.nav_prev()
			end)
			map("n", "<A-1>", function()
				ui.nav_file(1)
			end)
			map("n", "<A-2>", function()
				ui.nav_file(2)
			end)
			map("n", "<A-3>", function()
				ui.nav_file(3)
			end)
			map("n", "<A-4>", function()
				ui.nav_file(4)
			end)
		end,
	},
}
