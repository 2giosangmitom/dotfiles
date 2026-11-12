---@type config.LangSpec
return {
	servers = { "tombi" },
	tools = { "oxfmt" },
	parsers = { "toml" },
	formatters = { toml = { "oxfmt" } },
}
