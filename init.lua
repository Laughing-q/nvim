local core_modules = {
   "autocmds",
   "options",
   "mappings",
}

require "plugins.configs.global".setup()

for _, module in ipairs(core_modules) do
   local ok, err = pcall(require, module)
   if not ok then
      error("Error loading " .. module .. "\n\n" .. err)
   end
end

-- colorscheme
local ok, err = pcall(require, 'tokyonight')
if ok then
  vim.cmd("colorscheme " .. "tokyonight")
end
