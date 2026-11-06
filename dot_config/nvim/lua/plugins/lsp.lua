vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

require("plugins.mason")
require("plugins.blink-cmp")

vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

local servers = require("config.lang").list("servers")

for _, spec in ipairs(require("config.lang").specs()) do
	if spec.setup then
		spec.setup()
	end
end

vim.lsp.enable(servers)
