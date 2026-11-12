--- Language support is split into lua/lang/<name>.lua. Each file returns a
--- `config.LangSpec`, which the plugin modules collect.

---@class config.LangSpec
---@field servers? string[] LSP server names to enable (configs live in after/lsp/)
---@field tools? string[] Extra Mason packages (formatters, linters, debuggers)
---@field parsers? string[] Treesitter parsers
---@field formatters? table<string, string[]> conform.nvim formatters by filetype
---@field linters? table<string, string[]> nvim-lint linters by filetype
---@field dap? fun(dap: table) Debug adapters and configurations
---@field setup? fun() Anything else (filetypes, autocmds)
local M = {}

---@type config.LangSpec[]?
local specs

--- Load every spec in lua/lang/, once.
---@return config.LangSpec[]
function M.specs()
	if not specs then
		specs = {}
		local files = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/lang", "*.lua", false, true)
		table.sort(files)
		for _, file in ipairs(files) do
			local name = vim.fn.fnamemodify(file, ":t:r")
			local ok, spec = pcall(require, "lang." .. name)
			if not ok then
				vim.notify(("Failed to load language spec %q: %s"):format(name, spec), vim.log.levels.ERROR)
			elseif type(spec) ~= "table" then
				vim.notify(("Language spec %q must return a table"):format(name), vim.log.levels.ERROR)
			else
				table.insert(specs, spec)
			end
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
		result = vim.tbl_deep_extend("force", result, spec[field] or {})
	end
	return result
end

--- Run every spec's `setup` hook. Call after completion and LSP are configured.
function M.setup()
	for _, spec in ipairs(M.specs()) do
		if spec.setup then
			local ok, err = pcall(spec.setup)
			if not ok then
				vim.notify("Language setup failed: " .. err, vim.log.levels.ERROR)
			end
		end
	end
end

return M
