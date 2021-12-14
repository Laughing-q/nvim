local ok, null_ls = pcall(require, "null-ls")

if not ok then
   return
end

local b = null_ls.builtins

local sources = {

   -- Lua
   b.formatting.stylua,
   -- b.diagnostics.luacheck.with { extra_args = { "--global vim" } },

   -- Shell
   b.formatting.shfmt,
   b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },

   -- python
   b.formatting.yapf,

   -- latex
   b.diagnostics.chktex,
}

local M = {}

M.setup = function(on_attach)
   null_ls.setup {
      sources = sources,
   }
   require("null-ls").setup { on_attach = on_attach }
end

return M
