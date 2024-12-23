return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			{
				"nvim-tree/nvim-web-devicons",
			},
			{
				"ahmedkhalf/project.nvim",    -- need this plugin for now to find git root for telescope searching
				config = function()
					require("project_nvim").setup({
						---@usage set to true to disable setting the current-woriking directory
						--- Manual mode doesn't automatically change your root directory, so you have
						--- the option to manually do so using `:ProjectRoot` command.
						manual_mode = false, -- null-ls will disturb this when set `false`, but i'am not using null-ls.

						---@usage Methods of detecting the root directory
						--- Allowed values: **"lsp"** uses the native neovim lsp
						--- **"pattern"** uses vim-rooter like glob pattern matching. Here
						--- order matters: if one is not detected, the other is used as fallback. You
						--- can also delete or rearangne the detection methods.
						detection_methods = { "lsp", "pattern" },

						---@usage patterns used to detect root dir, when **"pattern"** is in detection_methods
						patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },

						---@ Show hidden files in telescope when searching for files in a project
						show_hidden = false,

						---@usage When set to false, you will get a message when project.nvim changes your directory.
						-- When set to false, you will get a message when project.nvim changes your directory.
						silent_chdir = true,

						---@usage list of lsp client names to ignore when using **lsp** detection. eg: { "efm", ... }
						ignore_lsp = {},

						---@type string
						---@usage path to store the project history for use in telescope
						datapath = vim.fn.stdpath("cache"),
					})
				end,
			},
		},
		config = function()
			require("lq.configs.telescope")
		end,
	},
}
