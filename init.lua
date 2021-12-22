local core_modules = {
	"autocmds",
	"options",
	"mappings",
}
pcall(require, "impatient")

for _, module in ipairs(core_modules) do
	local ok, err = pcall(require, module)
	if not ok then
		error("Error loading " .. module .. "\n\n" .. err)
	end
end

-- plugin global settings
require("plugins.configs.global").setup()
-- colorscheme
local ok, _ = pcall(require, "tokyonight")
if ok then
	vim.cmd("colorscheme " .. "tokyonight")
end
-- vim.notify("this is a test")
-- vim.lsp.set_log_level("debug")
