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
