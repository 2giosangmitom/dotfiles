-- JavaScript and TypeScript
local filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }

local function by_filetype(value)
	local result = {}
	for _, ft in ipairs(filetypes) do
		result[ft] = value
	end
	return result
end

return {
	servers = { "vtsls" },
	tools = { "oxfmt", "oxlint", "js-debug-adapter" },
	parsers = { "javascript", "typescript", "tsx", "jsdoc" },
	formatters = by_filetype({ "oxfmt" }),
	linters = by_filetype({ "oxlint" }),
}
