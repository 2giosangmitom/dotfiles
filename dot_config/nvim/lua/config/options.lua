-- Use <Space> as leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- UI
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.showmode = false
vim.opt.winborder = "single" -- Default border for floating windows
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.laststatus = 3 -- One statusline for all windows
vim.opt.shortmess:append("sI") -- No intro screen or "search hit BOTTOM" message
vim.opt.signcolumn = "yes" -- Keep the text from shifting when signs appear
vim.opt.fillchars:append({
	eob = " ",
	fold = " ",
	foldsep = " ",
	foldopen = require("config.icons").get("FoldOpened"),
	foldclose = require("config.icons").get("FoldClosed"),
	diff = "╱",
})

-- Indent
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftround = true -- Round > and < indentation to shiftwidth multiples

-- Search
vim.opt.inccommand = "split" -- Preview substitutions, including off-screen matches

-- Folding: treesitter by default, LSP folding ranges when a server provides them
-- (see config/lsp.lua). Start with every fold open.
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = "" -- Show the first line with its highlighting
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- Completion menu (used by built-in completion; blink.cmp draws its own)
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }
vim.opt.pumheight = 10

-- Editing and recovery
vim.opt.jumpoptions:append("view") -- Restore viewport on jumps; keep native flags
vim.opt.undolevels = 10000
vim.opt.writebackup = true -- Protect the original file while writing
vim.opt.confirm = true -- Offer to save instead of failing on unsaved changes
vim.opt.updatetime = 250 -- Faster CursorHold events and swap-file updates
vim.opt.timeoutlen = 400 -- Wait less for mapped key sequences
