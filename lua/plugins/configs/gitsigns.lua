local present, gitsigns = pcall(require, "gitsigns")
if not present then
	return
end

local opts = {
	signs = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	-- signs = {
	-- 	add = {
	-- 		text = "+",
	--      -- text = "▎",
	-- 	},
	-- 	change = {
	-- 		text = "~",
	--      -- text = "▎",
	-- 	},
	-- },
	numhl = true,
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
