vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.signcolumn = "yes"
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
vim.opt.completeopt = "menu,menuone,noselect"
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

vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })
