---@type config.LangSpec
return {
	servers = { "lua_ls" },
	tools = { "stylua" },
	parsers = { "lua", "luadoc" },
	formatters = { lua = { "stylua" } },
}
