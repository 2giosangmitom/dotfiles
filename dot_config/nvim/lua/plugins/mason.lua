vim.pack.add({
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
})

require("mason").setup()

local lang = require("config.lang")

-- Install LSP servers declared by language specs.
require("mason-lspconfig").setup({
	ensure_installed = lang.list("servers"),
	automatic_enable = false, -- Servers are enabled explicitly in plugins/lsp.lua
})

-- Install formatters, linters and debuggers declared by language specs.
local registry = require("mason-registry")
registry.refresh(function()
	for _, name in ipairs(lang.list("tools")) do
		local ok, pkg = pcall(registry.get_package, name)
		if not ok then
			vim.notify("Mason package not found: " .. name, vim.log.levels.WARN)
		elseif not pkg:is_installed() and not pkg:is_installing() then
			pkg:install()
		end
	end
end)
