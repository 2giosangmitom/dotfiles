vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/b0o/SchemaStore.nvim" },
})

require("plugins.mason")
require("plugins.blink-cmp")

local lang = require("config.lang")
local servers = lang.list("servers")

vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- Buffer-local LSP maps. Neovim already provides K, grn, gra, grr, gri, grO
-- and the default ]d/[d diagnostic jumps.
local function on_attach(_, bufnr)
	local map = function(lhs, rhs, desc)
		vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
	end

	map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
	map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
	map("<leader>ca", vim.lsp.buf.code_action, "Code action")
	map("]e", function()
		vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
	end, "Next error")
	map("[e", function()
		vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
	end, "Previous error")
end

for _, spec in ipairs(lang.specs()) do
	if spec.setup then
		spec.setup()
	end
end

-- Server options live in after/lsp/<server>.lua. Only wrap on_attach here so
-- shared maps, nvim-lspconfig's own callbacks (e.g. clangd commands) and the
-- after/lsp callback all run instead of the last one replacing the others.
for _, name in ipairs(servers) do
	local base = vim.lsp.config[name] or {}
	local base_attach = base.on_attach
	vim.lsp.config(name, {
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
			if base_attach then
				base_attach(client, bufnr)
			end
		end,
	})
end

vim.lsp.enable(servers)
