local M = {}

local opts = {
	-- size can be a number or function which is passed the current terminal
	size = 20,
	open_mapping = [[<c-\>]],
	hide_numbers = true, -- hide the number column in toggleterm buffers
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
	start_in_insert = true,
	insert_mappings = true, -- whether or not the open mapping applies in insert mode
	persist_size = false,
	-- direction = 'vertical' | 'horizontal' | 'window' | 'float',
	direction = "float",
	close_on_exit = true, -- close the terminal window when the process exits
	shell = vim.o.shell, -- change the default shell
	-- This field is only relevant if direction is set to 'float'
	float_opts = {
		-- The border key is *almost* the same as 'nvim_win_open'
		-- see :h nvim_win_open for details on borders however
		-- the 'curved' border is a custom border type
		-- not natively supported but implemented in this plugin.
		-- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
		border = "curved",
		-- width = <value>,
		-- height = <value>,
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
	-- Add executables on the config.lua
	-- { exec, keymap, name}
	-- laughing.builtin.terminal.execs = {{}} to overwrite
	-- laughing.builtin.terminal.execs[#laughing.builtin.terminal.execs+1] = {"gdb", "tg", "GNU Debugger"}
	execs = {
		{ "lazygit", "gg" },
		-- { "lf", "f", "f" },
	},
}

local add_exec = function(exec, keymap)
	vim.api.nvim_set_keymap(
		"n",
		"<leader>" .. keymap,
		"<cmd>lua _exec_toggle('" .. exec .. "')<CR>",
		{ noremap = true, silent = true }
	)
end

_exec_toggle = function(exec)
	local Terminal = require("toggleterm.terminal").Terminal
	local exec_term = Terminal:new({ cmd = exec, hidden = true })
	exec_term:toggle()
end

M.setup = function()
	local terminal = require("toggleterm")
	for _, exec in pairs(opts.execs) do
		add_exec(exec[1], exec[2], exec[3])
	end
	terminal.setup(opts)
end

return M
