-- Vue 3 uses the TypeScript plugin bundled with Mason's vue-language-server.
local vue_ls_path = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

return {
	servers = {
		vue_ls = {},
		-- Merged into the vtsls config from lang/typescript.lua.
		vtsls = {
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
			settings = {
				vtsls = {
					tsserver = {
						globalPlugins = {
							{
								name = "@vue/typescript-plugin",
								location = vue_ls_path,
								languages = { "vue" },
								configNamespace = "typescript",
							},
						},
					},
				},
			},
		},
	},
	tools = { "oxfmt", "oxlint" },
	parsers = { "vue", "css" },
	formatters = { vue = { "oxfmt" } },
	linters = { vue = { "oxlint" } },
}
