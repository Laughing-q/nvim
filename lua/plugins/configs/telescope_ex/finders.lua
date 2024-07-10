-- in lua/finders.lua
local finders = {}

-- Dropdown list theme using a builtin theme definitions :
local center_list = require("telescope.themes").get_dropdown({
	-- winblend = 10,
	width = 0.5,
	prompt = "   ",
	results_height = 15,
	previewer = false,
})

-- Find files with_preview settings
finders.ff = function()
	local opts = vim.deepcopy(center_list)
	require("telescope.builtin").fd(opts)
end

finders.fo = function()
	local opts = vim.deepcopy(center_list)
	opts.layout_config = { height = 0.6, width = 0.6 }
	require("telescope.builtin").oldfiles(opts)
end

finders.fs = function()
	local opts = vim.deepcopy(center_list)
	require("telescope.builtin").spell_suggest(opts)
end

finders.fn = function()
	local opts = vim.deepcopy(center_list)
	opts.layout_config = { height = 0.6, width = 0.7 }
	require("telescope.builtin").current_buffer_fuzzy_find(opts)
end

finders.fj = function()
	local opts = vim.deepcopy(center_list)
	opts.layout_config = { height = 0.6 }
	require("telescope.builtin").grep_string(opts)
end

return finders
