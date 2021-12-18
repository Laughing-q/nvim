local on_attach = require('plugins.configs.lsp.lspconfig').on_attach
local capabilities = require('plugins.configs.lsp.lspconfig').capabilities

local M = {}

M.setup_lsp = function()
	local lsp_installer = require("nvim-lsp-installer")

	lsp_installer.on_server_ready(function(server)
		local opts = {
			on_attach = on_attach,
			capabilities = capabilities,
			flags = {
				debounce_text_changes = 150,
			},
			settings = {},
		}
		if server.name == "pyright" then
			opts.settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						diagnosticMode = "workspace",
						useLibraryCodeForTypes = true,
						typeCheckingMode = "off",
						logLevel = "Warning",
						diagnosticSeverityOverrides = {
							reportUnusedImport = "off",
						},
					},
				},
			}
		end

		server:setup(opts)
		vim.cmd([[ do User LspAttachBuffers ]])
	end)
end

return M
