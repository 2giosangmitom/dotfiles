---@type config.LangSpec
return {
	servers = { "cssls" },
	parsers = { "css", "scss" },
	formatters = {
		css = { "oxfmt" },
		scss = { "oxfmt" },
		less = { "oxfmt" },
	},
}
