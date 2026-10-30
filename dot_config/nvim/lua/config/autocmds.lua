-- Highlight on yank is provided by mini.basics.
local group = vim.api.nvim_create_augroup("user_autocmds", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

-- Reload files changed outside Neovim
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = group,
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

-- Keep splits equal when the terminal is resized
autocmd("VimResized", {
	group = group,
	callback = function()
		local tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. tab)
	end,
})

-- Restore cursor to the last position when reopening a file
autocmd("BufReadPost", {
	group = group,
	callback = function(event)
		if vim.bo[event.buf].filetype == "gitcommit" then
			return
		end
		local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
		if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(event.buf) then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Close utility windows with q
autocmd("FileType", {
	group = group,
	pattern = { "help", "qf", "man", "checkhealth", "lspinfo", "nvim-pack" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", function()
			pcall(vim.cmd.close)
			pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
		end, { buffer = event.buf, silent = true, nowait = true, desc = "Close window" })
	end,
})

-- Wrap and spell check prose
autocmd("FileType", {
	group = group,
	pattern = { "gitcommit", "markdown", "text" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Create missing parent directories on save
autocmd("BufWritePre", {
	group = group,
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return -- Skip URLs such as oil:// or scp://
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})
