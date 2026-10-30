local icons = require("config.icons").diagnostics
local severity = vim.diagnostic.severity

local severity_icons = {
	[severity.ERROR] = icons.Error,
	[severity.WARN] = icons.Warn,
	[severity.INFO] = icons.Info,
	[severity.HINT] = icons.Hint,
}

vim.diagnostic.config({
	severity_sort = true,
	update_in_insert = false,
	underline = true,
	virtual_text = {
		spacing = 4,
		source = "if_many",
		prefix = function(diagnostic)
			return severity_icons[diagnostic.severity]
		end,
	},
	signs = { text = severity_icons },
	float = { source = "if_many" },
})
