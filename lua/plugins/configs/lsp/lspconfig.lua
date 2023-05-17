local present, lspconfig = pcall(require, "lspconfig")

if not present then
	return
end

local M = {}

require "plugins.configs.lsp.ui"

-- Highlight word
local function setup_document_highlight(client, bufnr)
  local status_ok, highlight_supported = pcall(function()
    return client.supports_method "textDocument/documentHighlight"
  end)
  if not status_ok or not highlight_supported then
    return
  end
  vim.cmd [[hi LspReferenceRead cterm=bold ctermbg=red guibg=#145b7d]]
  vim.cmd [[hi LspReferenceText cterm=bold ctermbg=red guibg=#63434f]]
  vim.cmd [[hi LspReferenceWrite cterm=bold ctermbg=red guibg=#145b7d]]
  local group = "lsp_document_highlight"
  local hl_events = { "CursorHold", "CursorHoldI" }

  local ok, hl_autocmds = pcall(vim.api.nvim_get_autocmds, {
    group = group,
    buffer = bufnr,
    event = hl_events,
  })

  if ok and #hl_autocmds > 0 then
    return
  end

  vim.api.nvim_create_augroup(group, { clear = false })
  vim.api.nvim_create_autocmd(hl_events, {
    group = group,
    buffer = bufnr,
    callback = vim.lsp.buf.document_highlight,
  })
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = group,
    buffer = bufnr,
    callback = vim.lsp.buf.clear_references,
  })
end

-- keymapping
local function lsp_keymaps(bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	-- Enable completion triggered by <c-x><c-o>
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	local opts = { noremap = true, silent = true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "<A-x>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	buf_set_keymap("i", "<A-x>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	-- buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
	-- buf_set_keymap("n", "<space>fm", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	-- buf_set_keymap("v", "<space>ca", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
	-- buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	-- buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	-- buf_set_keymap("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	-- buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	-- buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	-- buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	-- buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	-- buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	-- buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
end

M.on_attach = function(client, bufnr)
	-- Highlight
	-- lsp_highlight_document(client)
  setup_document_highlight(client, bufnr)
	-- Keymappings
	lsp_keymaps(bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- Add additional capabilities supported by nvim-cmp
local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
	M.capabilities = capabilities
	return M
end
M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

local sumneko_opts = require("plugins.configs.lsp.settings.sumneko_lua")
local pyright_opts = require("plugins.configs.lsp.settings.pyright")
local pylsp_opts = require("plugins.configs.lsp.settings.pylsp")

lspconfig.lua_ls.setup({
	on_attach = M.on_attach,
	capabilities = M.capabilities,

	settings = sumneko_opts.settings,
})

lspconfig.bashls.setup{
	on_attach = M.on_attach,
	capabilities = M.capabilities,

	filetype = { "sh", "bash" },
}

lspconfig.pyright.setup{
	on_attach = M.on_attach,
	capabilities = M.capabilities,

	settings = pyright_opts.settings,
}

lspconfig.clangd.setup{
	on_attach = M.on_attach,
	capabilities = M.capabilities,
}

-- lspconfig.pylsp.setup({
-- 	on_attach = M.on_attach,
-- 	capabilities = M.capabilities,
--
-- 	pylsp_opts,
-- })

return M
