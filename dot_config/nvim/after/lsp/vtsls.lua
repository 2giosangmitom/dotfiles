local filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
local vue_server = require("config.mise").where("npm:@vue/language-server")
-- mise's npm backend hoists dependencies here, so tsserver can resolve
-- @vue/typescript-plugin from this location.
local vue_plugin = vue_server and vue_server .. "/node_modules/.mise"
local global_plugins = {}

-- Vue support uses the TypeScript plugin installed with mise's vue-language-server.
if vue_plugin and vim.uv.fs_stat(vue_plugin .. "/node_modules/@vue/typescript-plugin") then
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
