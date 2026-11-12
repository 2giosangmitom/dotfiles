-- Cache compiled Lua modules for faster startup
vim.loader.enable()

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.commands")
require("config.diagnostics")
require("config.loader")
require("config.plugins")
