local present, telescope = pcall(require, "telescope")
if not present then
	return
end

local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")

telescope.setup({
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},
		prompt_prefix = "   ",
		selection_caret = " ",
		entry_prefix = "  ",
		initial_mode = "insert",
		selection_strategy = "reset",
		-- sorting_strategy = "descending",
		sorting_strategy = "ascending",
		layout_strategy = "vertical",
		layout_config = {
			horizontal = {
				prompt_position = "top",
        mirror = true,
				preview_width = 0.5,
				-- results_width = 0.8,
			},
			vertical = {
				prompt_position = "top",
				mirror = true,
			},
		},
		file_sorter = require("telescope.sorters").get_fuzzy_file,
		file_ignore_patterns = { "node_modules" },
		generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
		path_display = { "absolute" },
		winblend = 0,
		border = {},
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		color_devicons = true,
		use_less = true,
		set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
		-- Developer configurations: Not meant for general override
		buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
		mappings = {
			i = {
				["<C-k>"] = actions.move_selection_next,
				["<C-i>"] = actions.move_selection_previous,
				["<tab>"] = actions.move_selection_previous,
				["<C-c>"] = actions.close,
				["<C-n>"] = actions.cycle_history_next,
				["<C-p>"] = actions.cycle_history_prev,
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
				["<M-l>"] = action_layout.toggle_preview,
			},
			n = {
				["<C-n>"] = actions.move_selection_next,
				["<C-p>"] = actions.move_selection_previous,
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
				["<M-l>"] = action_layout.toggle_preview,

				["k"] = actions.move_selection_next,
				["i"] = actions.move_selection_previous,
				-- ["<c-t>"] = trouble.open_with_trouble,
				-- ["<C-i>"] = my_cool_custom_action,
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
	},
})

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "harpoon")

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", function()
	builtin.find_files(require("telescope.themes").get_dropdown({ layout_config = { width = 0.5 }, previewer = false }))
end, { desc = "Find File" })

vim.keymap.set("n", "<leader>fo", function()
	builtin.oldfiles(
		require("telescope.themes").get_dropdown({ layout_config = { height = 0.6, width = 0.6 }, previewer = false })
	)
end, { desc = "Find Old File" })

vim.keymap.set("n", "<leader>fs", function()
	builtin.spell_suggest(
		require("telescope.themes").get_cursor({ layout_config = { height = 0.4, width = 0.5 }, previewer = false })
	)
end, { desc = "Find Spell" })

vim.keymap.set("n", "<leader>fn", function()
	builtin.current_buffer_fuzzy_find(
		require("telescope.themes").get_dropdown({ layout_config = { height = 0.6, width = 0.7 }, previewer = false })
	)
end, { desc = "Find Word in current buffer" })

vim.keymap.set("n", "<leader>fa", function()
	builtin.find_files({ width = 0.5, previewer = false, hidden = true })
end, { desc = "Find Hidden File" })

vim.keymap.set("n", "<leader>fj", builtin.grep_string, { desc = "Find Word under the cursor" })
vim.keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "Find Word" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help" })
vim.keymap.set("n", "<leader>fr", builtin.registers, { desc = "Find Registers" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find Keymaps" })
vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Find Commands" })

-- NOTE: rarely used
-- vim.keymap.set("n", "<leader>fb", builtin.buffer, { "Find Buffers" })
-- vim.keymap.set("n", "<leader>fC", builtin.colorscheme, { "Find Colorscheme" })
-- vim.keymap.set("n", "<leader>fM", builtin.man_pages, { "Find Man Pages" })
