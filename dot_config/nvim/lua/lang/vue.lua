-- Vue 3 uses the TypeScript plugin bundled with Mason's vue-language-server.
-- vtsls config (including the Vue plugin) lives in after/lsp/vtsls.lua.
return {
	servers = { "vue_ls" },
	tools = { "oxlint" },
	parsers = { "vue" },
	formatters = { vue = { "oxfmt" } },
	linters = { vue = { "oxlint" } },
}
