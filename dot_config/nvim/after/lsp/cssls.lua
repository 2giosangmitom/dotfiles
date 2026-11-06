---@type vim.lsp.Config
return {
	-- cssls provides completion/diagnostics; formatting falls back to prettier.
	filetypes = { "css", "scss", "less" },
}
