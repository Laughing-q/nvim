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
			local harpoon_extensions = require("harpoon.extensions")
			harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
			harpoon:extend({
				UI_CREATE = function(cx)
					vim.keymap.set("n", "<C-v>", function()
						harpoon.ui:select_menu_item({ vsplit = true })
					end, { buffer = cx.bufnr })

					vim.keymap.set("n", "<C-x>", function()
						harpoon.ui:select_menu_item({ split = true })
					end, { buffer = cx.bufnr })

					vim.keymap.set("n", "<C-t>", function()
						harpoon.ui:select_menu_item({ tabedit = true })
					end, { buffer = cx.bufnr })
				end,
			})
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
