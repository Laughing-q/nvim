local M = {}

local opts = {
  enable_persistent_history = true,
	keys = {
		telescope = {
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
	},
}

function M.setup()
  local present, neoclip = pcall(require, "neoclip")
  if not present then
    return
  end
	neoclip.setup(opts)
end

return M
