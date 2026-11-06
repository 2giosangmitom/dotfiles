---@type vim.lsp.Config
return {
	on_attach = function(client)
		-- Let ty handle type information and hover; Ruff handles linting and fixes.
		client.server_capabilities.hoverProvider = false
	end,
}
