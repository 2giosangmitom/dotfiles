-- Vue 3 uses the TypeScript plugin installed alongside mise's vue-language-server.
-- The vtsls side of the integration lives in after/lsp/vtsls.lua.
---@type config.LangSpec
return {
	servers = { "vue_ls" },
	parsers = { "vue" },
	formatters = { vue = { "oxfmt" } },
	linters = { vue = { "oxlint" } },
}
