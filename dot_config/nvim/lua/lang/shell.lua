---@type config.LangSpec
return {
	servers = { "bashls" },
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
