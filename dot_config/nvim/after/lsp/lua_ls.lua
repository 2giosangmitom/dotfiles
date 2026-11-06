local library = { vim.env.VIMRUNTIME }
local lspconfig = vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1]
if lspconfig then
	table.insert(library, lspconfig)
end

---@type vim.lsp.Config
return {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				-- Makes `vim` and Neovim's type annotations visible to lua_ls.
				library = library,
			},
			telemetry = { enable = false },
		},
	},
}
