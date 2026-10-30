vim.pack.add({
	{ src = "https://github.com/mason-org/mason.nvim" },
})

require("mason").setup()

-- Install formatters, linters and debuggers declared by language specs.
-- LSP servers are installed by mason-lspconfig in plugins/lsp.lua.
local registry = require("mason-registry")
registry.refresh(function()
	for _, name in ipairs(require("config.lang").list("tools")) do
		local ok, pkg = pcall(registry.get_package, name)
		if not ok then
			vim.notify("Mason package not found: " .. name, vim.log.levels.WARN)
		elseif not pkg:is_installed() and not pkg:is_installing() then
			pkg:install()
		end
	end
end)
