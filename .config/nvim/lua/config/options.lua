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
opt.conceallevel = 2
opt.inccommand = "nosplit"
opt.laststatus = 3
opt.list = true
opt.linebreak = true
opt.pumblend = 10
opt.pumheight = 10
opt.scrolloff = 4
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.sidescrolloff = 8

-- Indent
opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true
opt.smartindent = true

-- General
opt.updatetime = 200
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.undofile = true
opt.undolevels = 10000
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"
opt.ignorecase = true
opt.smoothscroll = true

-- Diagnostic
vim.diagnostic.config({
  virtual_text = true,
})
