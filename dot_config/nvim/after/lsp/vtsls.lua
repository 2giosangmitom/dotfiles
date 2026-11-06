local vue_ls_path = vim.fn.stdpath("data")
	.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

---@type vim.lsp.Config
return {
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
	settings = {
		vtsls = {
			autoUseWorkspaceTsdk = true,
			tsserver = {
				globalPlugins = {
					{
						name = "@vue/typescript-plugin",
						location = vue_ls_path,
						languages = { "vue" },
						configNamespace = "typescript",
						-- Required: autoUseWorkspaceTsdk makes vtsls use the project's
						-- TypeScript, which ignores global plugins without this flag.
						enableForWorkspaceTypeScriptVersions = true,
					},
				},
			},
		},
		typescript = { updateImportsOnFileMove = { enabled = "always" } },
		javascript = { updateImportsOnFileMove = { enabled = "always" } },
	},
}
