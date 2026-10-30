vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
})

require("plugins.mason")
require("plugins.blink-cmp")

vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- Configure each spec separately so several languages can extend one server
-- (e.g. vue adds its TypeScript plugin to vtsls); vim.lsp.config deep-merges.
local servers = {}
for _, spec in ipairs(require("config.lang").specs()) do
	if spec.setup then
		spec.setup()
	end
	for name, config in pairs(spec.servers or {}) do
		vim.lsp.config(name, config)
		servers[name] = true
	end
end
servers = vim.tbl_keys(servers)

require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_enable = false, -- Only enable servers declared by language specs
})

vim.lsp.enable(servers)
