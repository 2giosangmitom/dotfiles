local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.showmode = false
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}

-- Indent
opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true

-- General
opt.updatetime = 300

-- Diagnostic
vim.diagnostic.config({
  virtual_text = true
})
