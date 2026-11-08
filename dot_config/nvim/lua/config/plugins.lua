-- Load plugin groups in dependency order; each handles its own installation and setup.
--   ui          colorscheme, icons, statusline, tabline, visual helpers
--   editor      editing defaults, text objects, git, treesitter
--   navigation  pickers, file explorer, windows, buffers
--   lsp         Mason, completion, LSP, formatting, linting
--   dap         debugging
for _, name in ipairs({ "ui", "editor", "navigation", "lsp", "dap" }) do
	require("plugins." .. name)
end
