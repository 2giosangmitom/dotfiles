-- Language support is split into lua/lang/<name>.lua. Each file returns a spec
-- with any of these fields, which the plugin modules collect:
--   servers    table<string, vim.lsp.Config>  LSP servers to configure and enable
--   tools      string[]                       Extra Mason packages (formatters, linters, debuggers)
--   parsers    string[]                       Treesitter parsers
--   formatters table<string, string[]>        conform.nvim formatters by filetype
--   linters    table<string, string[]>        nvim-lint linters by filetype
--   dap        fun(dap)                       Debug adapters and configurations
--   setup      fun()                          Anything else (filetypes, autocmds)
local M = {}

local specs

---@return table[]
function M.specs()
	if not specs then
		specs = {}
		local files = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/lang", "*.lua", false, true)
		for _, file in ipairs(files) do
			table.insert(specs, require("lang." .. vim.fn.fnamemodify(file, ":t:r")))
		end
	end
	return specs
end

--- Concatenate a list field across all specs, without duplicates.
---@param field string
---@return string[]
function M.list(field)
	local result = {}
	for _, spec in ipairs(M.specs()) do
		vim.list_extend(result, spec[field] or {})
	end
	return vim.list.unique(result)
end

--- Merge a filetype-keyed field across all specs.
---@param field string
---@return table
function M.map(field)
	local result = {}
	for _, spec in ipairs(M.specs()) do
		result = vim.tbl_extend("force", result, spec[field] or {})
	end
	return result
end

return M
