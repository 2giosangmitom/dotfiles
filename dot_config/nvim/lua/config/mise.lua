--- Development tools (LSP servers, formatters, linters, debuggers) are
--- installed by mise from ~/.config/mise/config.toml.
local M = {}

-- Put mise's shims on PATH, so tools resolve even when Neovim is not
-- started from a shell that ran `mise activate`.
local shims = vim.fn.stdpath("data"):gsub("nvim$", "mise") .. "/shims"
if vim.env.MISE_DATA_DIR then
	shims = vim.env.MISE_DATA_DIR .. "/shims"
end
if not vim.tbl_contains(vim.split(vim.env.PATH or "", ":", { plain = true }), shims) then
	vim.env.PATH = shims .. ":" .. (vim.env.PATH or "")
end

---@type table<string, string|false>
local cache = {}

--- Install directory of a mise tool, e.g. `M.where("http:jdtls")`.
---@param tool string
---@return string? dir nil when mise or the tool is not installed
function M.where(tool)
	if cache[tool] == nil then
		local ok, result = pcall(function()
			return vim.system({ "mise", "where", tool }, { text = true }):wait()
		end)
		cache[tool] = ok and result.code == 0 and vim.trim(result.stdout) or false
	end
	return cache[tool] or nil
end

return M
