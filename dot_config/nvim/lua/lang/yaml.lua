vim.pack.add({
	{ src = "https://github.com/b0o/SchemaStore.nvim" },
})

return {
	servers = {
		yamlls = {
			settings = {
				yaml = {
					-- Use SchemaStore.nvim instead of yamlls' built-in store.
					schemaStore = { enable = false, url = "" },
					schemas = require("schemastore").yaml.schemas(),
				},
			},
		},
	},
	tools = { "oxfmt" },
	parsers = { "yaml" },
	formatters = { yaml = { "oxfmt" } },
}
