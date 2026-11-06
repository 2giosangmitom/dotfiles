---@type vim.lsp.Config
return {
	settings = {
		yaml = {
			-- Use SchemaStore.nvim instead of yamlls' built-in store.
			schemaStore = { enable = false, url = "" },
			schemas = require("schemastore").yaml.schemas(),
		},
	},
}
