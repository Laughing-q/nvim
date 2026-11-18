local parsers = {
	"python",
	"dockerfile",
	"lua",
	"vim",
	"vimdoc",
	"bash",
	"yaml",
	"markdown",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install(parsers)
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local lang = vim.treesitter.language.get_lang(args.match)
					if lang and vim.tbl_contains(parsers, lang) then
						vim.treesitter.start(args.buf, lang)
						vim.bo[args.buf].syntax = "ON"
					end
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		event = "VimEnter",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
			})

			local select = require("nvim-treesitter-textobjects.select")
			local keymaps = {
				aa = "@parameter.outer",
				ha = "@parameter.inner",
				af = "@function.outer",
				hf = "@function.inner",
				ac = "@class.outer",
				hc = "@class.inner",
			}
			for lhs, query in pairs(keymaps) do
				vim.keymap.set({ "x", "o" }, lhs, function()
					select.select_textobject(query, "textobjects")
				end)
			end

			local swap = require("nvim-treesitter-textobjects.swap")
			vim.keymap.set("n", "<leader>s", function()
				swap.swap_next("@parameter.inner")
			end)
			vim.keymap.set("n", "<leader>S", function()
				swap.swap_previous("@parameter.inner")
			end)
		end,
	},
}
