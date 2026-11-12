---@type config.LangSpec
return {
	servers = { "bashls" },
	tools = { "shfmt", "shellcheck" },
	parsers = { "bash" },
	formatters = {
		sh = { "shfmt" },
		bash = { "shfmt" },
	},
	linters = {
		sh = { "shellcheck" },
		bash = { "shellcheck" },
	},
}
