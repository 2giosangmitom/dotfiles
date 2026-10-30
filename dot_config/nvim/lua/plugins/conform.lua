vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})

local conform = require("conform")

conform.setup({
	formatters_by_ft = require("config.lang").map("formatters"),
	default_format_opts = { lsp_format = "fallback" },
	format_on_save = function(buf)
		if vim.g.disable_autoformat or vim.b[buf].disable_autoformat then
			return
		end
		return { timeout_ms = 3000 }
	end,
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set({ "n", "x" }, "<leader>cf", function()
	conform.format()
end, { desc = "Format" })

vim.keymap.set("n", "<leader>uf", function()
	vim.g.disable_autoformat = not vim.g.disable_autoformat
	vim.notify("Format on save " .. (vim.g.disable_autoformat and "disabled" or "enabled"))
end, { desc = "Toggle format on save" })
