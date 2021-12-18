local M = {}

local opts = {
	enable_persistant_history = true,
	keys = {
		i = {
			select = "<cr>",
			paste = "<c-p>",
			paste_behind = "<c-l>",
			custom = {},
		},
		n = {
			select = "<cr>",
			paste = "p",
			paste_behind = "P",
			custom = {},
		},
	},
}

function M.setup()
	local neoclip = require("neoclip")

	neoclip.setup(opts)
end

return M
