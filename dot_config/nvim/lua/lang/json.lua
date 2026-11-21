---@type config.LangSpec
return {
	servers = { "jsonls" },
	parsers = { "json", "json5" },
	formatters = {
		json = { "oxfmt" },
		jsonc = { "oxfmt" },
		json5 = { "oxfmt" },
	},
}
