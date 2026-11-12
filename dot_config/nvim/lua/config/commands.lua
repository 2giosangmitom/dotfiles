--- User commands.

vim.api.nvim_create_user_command("Pack", function()
	require("config.pack-ui").open()
end, { desc = "Open vim.pack UI" })
