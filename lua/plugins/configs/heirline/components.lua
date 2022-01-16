local M = {}
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local colors = {
	red = utils.get_highlight("DiagnosticError").fg,
	green = utils.get_highlight("String").fg,
	blue = utils.get_highlight("Function").fg,
	gray = utils.get_highlight("NonText").fg,
	orange = utils.get_highlight("DiagnosticWarn").fg,
	purple = utils.get_highlight("Statement").fg,
	cyan = utils.get_highlight("Special").fg,
	diag = {
		warn = utils.get_highlight("DiagnosticWarn").fg,
		error = utils.get_highlight("DiagnosticError").fg,
		hint = utils.get_highlight("DiagnosticHint").fg,
		info = utils.get_highlight("DiagnosticInfo").fg,
	},
	git = {
		del = utils.get_highlight("diffDeleted").fg,
		add = utils.get_highlight("diffAdded").fg,
		change = utils.get_highlight("diffChanged").fg,
	},
}

M.Git = {
	condition = conditions.is_git_repo,

	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
		self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
	end,

	hl = { fg = "white", bg = "#223249" },

	{ -- git branch name
		provider = function(self)
			return " 🐯" .. self.status_dict.head .. " "
		end,
		-- hl = { style = "bold" },
	},
	-- {
	-- 	condition = function(self)
	-- 		return self.has_changes
	-- 	end,
	-- 	provider = " ",
	-- },
	{
		provider = function(self)
			local count = self.status_dict.added or 0
			return count > 0 and ("  " .. count)
		end,
		hl = { fg = "#45b97c", bg = "black"},
	},
	{
		provider = function(self)
			local count = self.status_dict.changed or 0
			return count > 0 and ("  " .. count)
		end,
		hl = { fg = "#dea32c", bg = "black"},
	},
	{
		provider = function(self)
			local count = self.status_dict.removed or 0
			return count > 0 and ("  " .. count)
		end,
		hl = { fg = "#f15b6c", bg = "black" },
	},
}


-- I take no credits for this! :lion:
M.ScrollBar = {
	static = {
		sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
	},
	provider = function(self)
		local curr_line = vim.api.nvim_win_get_cursor(0)[1]
		local lines = vim.api.nvim_buf_line_count(0)
		local i = math.floor(curr_line / lines * (#self.sbar - 1)) + 1
		return string.rep(self.sbar[i], 2)
	end,
}
M.Align = { provider = "%=" }
M.Space = { provider = " " }

return M
