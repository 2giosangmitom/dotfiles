return {
	servers = { "bashls" },
	tools = { "bash-language-server", "shfmt", "shellcheck" },
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
