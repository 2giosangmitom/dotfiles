local icons = require("config.icons")
local severity = vim.diagnostic.severity

local severity_icons = {
	[severity.ERROR] = icons.get("DiagnosticError"),
	[severity.WARN] = icons.get("DiagnosticWarn"),
	[severity.INFO] = icons.get("DiagnosticInfo"),
	[severity.HINT] = icons.get("DiagnosticHint"),
}

-- Inline message on every line except the cursor line, which gets virtual lines.
local virtual_text = {
	current_line = false,
	spacing = 4,
	source = "if_many",
	prefix = function(diagnostic)
		return severity_icons[diagnostic.severity]
	end,
}

vim.diagnostic.config({
	severity_sort = true,
	virtual_text = virtual_text,
	-- Full multi-line message under the cursor line. This also covers jumps, so
	-- `jump.on_jump` doesn't need to open a float.
	virtual_lines = { current_line = true },
	signs = { text = severity_icons }, -- Also used by vim.diagnostic.status()
	float = {
		source = "if_many",
		header = "",
		prefix = function(diagnostic)
			local name = vim.diagnostic.severity[diagnostic.severity]
			local hl = "Diagnostic" .. name:sub(1, 1) .. name:sub(2):lower()
			return severity_icons[diagnostic.severity] .. " ", hl
		end,
	},
})

---@param diagnostic_severity vim.diagnostic.Severity
---@param count integer
---@return fun()
local function jump(diagnostic_severity, count)
	return function()
		vim.diagnostic.jump({ count = count, severity = diagnostic_severity })
	end
end

local map = vim.keymap.set
map("n", "]e", jump(severity.ERROR, 1), { desc = "Next error" })
map("n", "[e", jump(severity.ERROR, -1), { desc = "Previous error" })
map("n", "]w", jump(severity.WARN, 1), { desc = "Next warning" })
map("n", "[w", jump(severity.WARN, -1), { desc = "Previous warning" })

-- Switch between virtual lines on the cursor line only (plus virtual text
-- elsewhere) and virtual lines on every line.
map("n", "<leader>ud", function()
	local all = vim.diagnostic.config().virtual_lines.current_line
	vim.diagnostic.config({
		virtual_lines = { current_line = not all },
		virtual_text = not all and virtual_text,
	})
	vim.notify("Diagnostic lines: " .. (all and "all lines" or "cursor line"))
end, { desc = "Toggle diagnostic lines" })
