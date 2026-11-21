---@type config.LangSpec
return {
	servers = { "lua_ls" },
	parsers = { "lua", "luadoc" },
	formatters = { lua = { "stylua" } },
}
