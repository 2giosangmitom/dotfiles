vim.pack.add({
	{ src = "https://github.com/b0o/SchemaStore.nvim" },
})

return {
	servers = {
		jsonls = {
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			},
		},
	},
	tools = { "oxfmt" },
	parsers = { "json", "json5" },
	formatters = {
		json = { "oxfmt" },
		jsonc = { "oxfmt" },
		json5 = { "oxfmt" },
	},
}
