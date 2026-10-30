return {
	servers = {
		lua_ls = {
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					workspace = {
						checkThirdParty = false,
						library = { vim.env.VIMRUNTIME },
					},
				},
			},
		},
	},
	tools = { "stylua" },
	parsers = { "lua", "luadoc" },
	formatters = { lua = { "stylua" } },
}
