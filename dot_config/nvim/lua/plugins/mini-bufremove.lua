vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.bufremove" },
})

vim.keymap.set("n", "<leader>bd", function()
	require("mini.bufremove").delete()
end, { desc = "Delete buffer" })
