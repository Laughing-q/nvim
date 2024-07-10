local M = {}

M.luasnip = function()
	local present, luasnip = pcall(require, "luasnip")
	if not present then
		return
	end

	luasnip.config.set_config({
		history = true,
		updateevents = "TextChanged,TextChangedI",
	})

	require("luasnip/loaders/from_vscode").load({ paths = {} })
	require("luasnip/loaders/from_vscode").load()
end

M.scrollview = function()
	require("scrollview").setup({
		-- excluded_filetypes = { "nerdtree" },
		current_only = true,
		winblend = 75,
		base = "right",
		-- column = 80,
		signs_on_startup = { "search" }, -- search, diagnostic
		-- diagnostics_severities = { vim.diagnostic.severity.ERROR },
		search_symbol = "-",
	})
end

M.harpoon = function()
	-- harpoon
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
end

return M
