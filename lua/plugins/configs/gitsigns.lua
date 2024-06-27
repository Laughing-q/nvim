local present, gitsigns = pcall(require, "gitsigns")
if not present then
	return
end

local opts = {
	signs = {
		add = {
			text = "+",
      -- text = "▎",
		},
		change = {
			text = "~",
      -- text = "▎",
		},
		delete = {
			text = "-",
      -- text = "契",
		},
		topdelete = {
			text = "-",
      -- text = "契",
		},
		changedelete = {
			text = "+",
      -- text = "▎",
		},
	},
	numhl = false,
	linehl = false,
	watch_gitdir = {
		interval = 1000,
		follow_files = true,
	},
	sign_priority = 6,
	update_debounce = 200,
	status_formatter = nil, -- Use default
}

gitsigns.setup(opts)
