---@type config.LangSpec
return {
	servers = { "cssls" },
	tools = { "oxfmt" },
	parsers = { "css", "scss" },
	formatters = {
		css = { "oxfmt" },
		scss = { "oxfmt" },
		less = { "oxfmt" },
	},
}
