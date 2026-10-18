-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Use <Space> as leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- UI
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.showmode = false
vim.opt.winborder = "rounded" -- Default border for floating windows
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Indent
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftround = true -- Round > and < indentation to shiftwidth multiples

-- Search
vim.opt.inccommand = "split" -- Preview substitutions, including off-screen matches

-- Completion (built-in; no completion plugin required)
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }
vim.opt.pumheight = 10

-- Editing and recovery
vim.opt.jumpoptions:append("view") -- Restore viewport on jumps; keep native flags
vim.opt.undolevels = 10000
vim.opt.writebackup = true -- Protect the original file while writing
vim.opt.confirm = true -- Offer to save instead of failing on unsaved changes
vim.opt.updatetime = 250 -- Faster CursorHold events and swap-file updates
vim.opt.timeoutlen = 400 -- Wait less for mapped key sequences
