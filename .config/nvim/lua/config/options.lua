local icons = require("config.icons")

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.signcolumn = "yes"
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.opt.fillchars = {
	eob = " ",
}
vim.opt.wildmode = "longest:full,full"
vim.opt.wrap = true
vim.opt.scrolloff = 4
vim.opt.ruler = false
vim.opt.linebreak = true
vim.opt.termguicolors = true
vim.opt.smartindent = true
vim.opt.shiftround = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.showmode = false

-- Define diagnostic signs
for sign, icon in pairs(icons.Diagnostics) do
	vim.fn.sign_define("DiagnosticSign" .. sign, { text = icon, texthl = "DiagnosticSign" .. sign })
end

vim.diagnostic.config({
	virtual_text = {
		current_line = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.Diagnostics.Error,
			[vim.diagnostic.severity.WARN] = icons.Diagnostics.Warn,
			[vim.diagnostic.severity.HINT] = icons.Diagnostics.Hint,
			[vim.diagnostic.severity.INFO] = icons.Diagnostics.Info,
		},
	},
})
