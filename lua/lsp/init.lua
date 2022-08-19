local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("lsp.signature")
require("lsp.installer")
require("lsp.handlers").setup()
require("lsp.null-ls")

local lspconfig = require("lspconfig")

lspconfig.emmet_ls.setup({
	-- capabilities = capabilities,
	-- on_attach = on_attach,
	filetypes = { "html", "css", "typescriptreact", "javascriptreact" },
})
