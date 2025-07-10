return {
	{ -- Additional text objects via treesitter
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "VimEnter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			event = "VimEnter",
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = {
						"python",
						-- "c",
						-- "cpp",
						-- "cmake",
						-- "make",
						-- "cuda",
						"dockerfile",
						"lua",
						"vim",
						"vimdoc",
						"bash",
						"yaml",
						-- "bibtex",
						-- "latex",
						"markdown",
					}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
					ignore_install = {},
					highlight = {
						enable = true, -- false will disable the whole extension
						additional_vim_regex_highlighting = true,
						use_languagetree = true,
						-- disable = { "latex" },
					},

					textobjects = {
						select = {
							enable = true,
							lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
							keymaps = {
								-- You can use the capture groups defined in textobjects.scm
								["aa"] = "@parameter.outer",
								["ha"] = "@parameter.inner",
								["af"] = "@function.outer",
								["hf"] = "@function.inner",
								["ac"] = "@class.outer",
								["hc"] = "@class.inner",
							},
						},
						move = {
							enable = false,
							set_jumps = true, -- whether to set jumps in the jumplist
							goto_next_start = {
								["]]"] = "@function.outer",
								["]c"] = "@class.outer",
							},
							goto_next_end = {
								["]["] = "@function.outer",
								["]C"] = "@class.outer",
							},
							goto_previous_start = {
								["[["] = "@function.outer",
								["[c"] = "@class.outer",
							},
							goto_previous_end = {
								["[]"] = "@function.outer",
								["[C"] = "@class.outer",
							},
						},
						swap = {
							enable = true,
							swap_next = {
								["<leader>s"] = "@parameter.inner",
							},
							swap_previous = {
								["<leader>S"] = "@parameter.inner",
							},
						},
					},
				})
			end,
			dependencies = { "nvim-lua/plenary.nvim" },
		},
	},
}
