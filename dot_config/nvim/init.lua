require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.diagnostics")
require("config.plugins")

vim.api.nvim_create_user_command("Pack", function()
	require("config.pack-ui").open()
end, { desc = "Open vim.pack UI" })
