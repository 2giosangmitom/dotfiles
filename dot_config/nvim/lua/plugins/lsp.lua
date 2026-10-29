vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
})

require("plugins.mason")
require("plugins.blink-cmp")

vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
		},
	},
})

-- Vue 3 uses the TypeScript plugin bundled with Mason's vue-language-server.
local vue_ls_path = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

vim.lsp.config("vtsls", {
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = {
					{
						name = "@vue/typescript-plugin",
						location = vue_ls_path,
						languages = { "vue" },
						configNamespace = "typescript",
					},
				},
			},
		},
	},
})

-- Let ty provide type information and hover; Ruff handles linting and fixes.
vim.lsp.config("ruff", {
	on_attach = function(client)
		client.server_capabilities.hoverProvider = false
	end,
})

local servers = { "lua_ls", "rust_analyzer", "vtsls", "vue_ls", "jsonls", "yamlls", "ty", "ruff" }

require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_enable = servers,
})
