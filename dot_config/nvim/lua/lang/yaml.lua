---@type config.LangSpec
return {
	servers = { "yamlls" },
	tools = { "oxfmt" },
	parsers = { "yaml" },
	formatters = { yaml = { "oxfmt" } },
}
