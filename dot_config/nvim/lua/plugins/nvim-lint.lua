vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-lint" },
})

local lint = require("lint")

lint.linters_by_ft = require("config.lang").map("linters")

-- Some linters (e.g. oxlint) read the file from disk, so lint on read and write.
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
	group = vim.api.nvim_create_augroup("user_lint", { clear = true }),
	callback = function()
		lint.try_lint()
	end,
})
