---@brief
--- Native `vim.lsp` behavior shared by all language servers.
---
--- Everything is attached through a single `LspAttach` autocommand, so it only
--- applies to buffers whose server actually supports a feature, and it does not
--- interfere with per-server `on_attach` callbacks defined in `after/lsp/`.
---
--- Neovim already provides these buffer-local defaults, which are kept as is:
--- `K` (hover), `grn` (rename), `gra` (code action), `grx` (code lens),
--- `gO` (document symbols), `<C-s>` (signature help, Insert mode), `<C-]>`
--- (definition through `tagfunc`) and `]d`/`[d` (diagnostics).

local M = {}

local group = vim.api.nvim_create_augroup("user_lsp", { clear = true })

---@param bufnr integer
---@return fun(mode: string|string[], lhs: string, rhs: string|function, desc: string)
local function buffer_map(bufnr)
	return function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "LSP: " .. desc })
	end
end

--- Call a fzf-lua LSP picker lazily, so the picker is only loaded when used.
---@param picker string Name of a function in `fzf-lua`.
---@return fun()
local function pick(picker)
	return function()
		require("fzf-lua")[picker]()
	end
end

---@param diagnostic_severity vim.diagnostic.SeverityFilter?
---@param count integer
---@return fun()
local function jump_diagnostic(diagnostic_severity, count)
	return function()
		vim.diagnostic.jump({ count = count, severity = diagnostic_severity, float = true })
	end
end

--- Define buffer-local keymaps.
---@param client vim.lsp.Client
---@param bufnr integer
local function set_keymaps(client, bufnr)
	local map = buffer_map(bufnr)
	local methods = vim.lsp.protocol.Methods

	-- Navigation. fzf-lua jumps directly when there is a single result and
	-- opens a picker otherwise.
	if client:supports_method(methods.textDocument_definition) then
		map("n", "gd", pick("lsp_definitions"), "Go to definition")
	end
	if client:supports_method(methods.textDocument_declaration) then
		map("n", "gD", pick("lsp_declarations"), "Go to declaration")
	end
	if client:supports_method(methods.textDocument_typeDefinition) then
		map("n", "gy", pick("lsp_typedefs"), "Go to type definition")
		map("n", "grt", pick("lsp_typedefs"), "Go to type definition")
	end
	if client:supports_method(methods.textDocument_implementation) then
		map("n", "gri", pick("lsp_implementations"), "Go to implementation")
	end
	if client:supports_method(methods.textDocument_references) then
		map("n", "grr", pick("lsp_references"), "References")
	end
	if client:supports_method(methods.callHierarchy_incomingCalls) then
		map("n", "<leader>ci", pick("lsp_incoming_calls"), "Incoming calls")
	end
	if client:supports_method(methods.callHierarchy_outgoingCalls) then
		map("n", "<leader>co", pick("lsp_outgoing_calls"), "Outgoing calls")
	end

	-- Actions
	map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
	map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
	map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
	map("n", "]e", jump_diagnostic(vim.diagnostic.severity.ERROR, 1), "Next error")
	map("n", "[e", jump_diagnostic(vim.diagnostic.severity.ERROR, -1), "Previous error")
	map("n", "]w", jump_diagnostic(vim.diagnostic.severity.WARN, 1), "Next warning")
	map("n", "[w", jump_diagnostic(vim.diagnostic.severity.WARN, -1), "Previous warning")

	if client:supports_method(methods.textDocument_codeLens) then
		map({ "n", "x" }, "<leader>cl", vim.lsp.codelens.run, "Run code lens")
	end
	if client:supports_method(methods.textDocument_inlayHint) then
		map("n", "<leader>uh", function()
			local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
			vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
		end, "Toggle inlay hints")
	end
end

--- Enable optional server-driven features for a buffer.
---@param client vim.lsp.Client
---@param bufnr integer
local function enable_features(client, bufnr)
	local methods = vim.lsp.protocol.Methods

	if client:supports_method(methods.textDocument_codeLens) then
		vim.lsp.codelens.enable(true, { bufnr = bufnr })
	end

	-- Highlight other references to the symbol under the cursor.
	if client:supports_method(methods.textDocument_documentHighlight) then
		local highlight = vim.api.nvim_create_augroup(("user_lsp_highlight_%d"):format(bufnr), { clear = true })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = highlight,
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
			desc = "LSP: highlight references",
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
			group = highlight,
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
			desc = "LSP: clear references",
		})
	end
end

--- Remove buffer-local state once no attached client provides it anymore.
---@param bufnr integer
local function clear_features(bufnr)
	for _, other in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if other:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			return
		end
	end
	vim.api.nvim_clear_autocmds({ group = ("user_lsp_highlight_%d"):format(bufnr) })
	vim.lsp.buf.clear_references()
end

--- Register the shared LSP autocommands. Call once during startup.
function M.setup()
	vim.api.nvim_create_autocmd("LspAttach", {
		group = group,
		desc = "LSP: keymaps and features",
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if not client then
				return
			end
			set_keymaps(client, args.buf)
			enable_features(client, args.buf)
		end,
	})

	vim.api.nvim_create_autocmd("LspDetach", {
		group = group,
		desc = "LSP: clean up",
		callback = function(args)
			clear_features(args.buf)
		end,
	})
end

return M
