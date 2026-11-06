local filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
local vue_plugin = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
local global_plugins = {}

-- Vue support uses the TypeScript plugin bundled with Mason's vue-language-server.
if vim.uv.fs_stat(vue_plugin) then
	table.insert(filetypes, "vue")
	table.insert(global_plugins, {
		name = "@vue/typescript-plugin",
		location = vue_plugin,
		languages = { "vue" },
		configNamespace = "typescript",
		-- Required: autoUseWorkspaceTsdk makes vtsls use the project's
		-- TypeScript, which ignores global plugins without this flag.
		enableForWorkspaceTypeScriptVersions = true,
	})
end

---@type vim.lsp.Config
return {
	filetypes = filetypes,
	settings = {
		vtsls = {
			autoUseWorkspaceTsdk = true,
			tsserver = { globalPlugins = global_plugins },
		},
		typescript = { updateImportsOnFileMove = { enabled = "always" } },
		javascript = { updateImportsOnFileMove = { enabled = "always" } },
	},
}
