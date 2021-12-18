local ok, null_ls = pcall(require, "null-ls")

if not ok then
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local completion = null_ls.builtins.completion

local sources = {
	-- spell
	completion.spell,
	formatting.prettier,

	-- Lua
	formatting.stylua,
	-- b.diagnostics.luacheck.with { extra_args = { "--global vim" } },

	-- Shell
	formatting.shfmt,
	diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),

	-- python
	formatting.yapf.with({ args = {} }),
	-- formatting.black.with { extra_args = { "--fast" }},

	-- latex
	diagnostics.chktex,

	-- null_ls.builtins.code_actions.gitsigns
}

local M = {}

M.setup = function(on_attach)
	null_ls.setup({
		sources = sources,
		debug = false,
	})
	require("null-ls").setup({ on_attach = on_attach })
end

return M
