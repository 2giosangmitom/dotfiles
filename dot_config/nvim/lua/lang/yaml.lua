vim.pack.add({
	{ src = "https://github.com/b0o/SchemaStore.nvim" },
})

return {
	servers = { "yamlls" },
	tools = { "oxfmt" },
	parsers = { "yaml" },
	formatters = { yaml = { "oxfmt" } },
}
