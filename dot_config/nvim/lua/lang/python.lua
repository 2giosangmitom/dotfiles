-- Prefer the project's virtualenv for running the debuggee.
local function python_path()
	local venv = vim.env.VIRTUAL_ENV
	if not venv and vim.fn.isdirectory(vim.fn.getcwd() .. "/.venv") == 1 then
		venv = vim.fn.getcwd() .. "/.venv"
	end
	return venv and venv .. "/bin/python" or vim.fn.exepath("python3")
end

return {
	servers = {
		-- Let ty provide type information and hover; Ruff handles linting and fixes.
		ty = {},
		ruff = {
			on_attach = function(client)
				client.server_capabilities.hoverProvider = false
			end,
		},
	},
	tools = { "debugpy" },
	parsers = { "python" },
	formatters = { python = { "ruff_organize_imports", "ruff_format" } },
	dap = function(dap)
		dap.adapters.python = function(callback, config)
			if config.request == "attach" then
				local connect = config.connect or {}
				callback({ type = "server", host = connect.host or "127.0.0.1", port = connect.port or 5678 })
			else
				callback({ type = "executable", command = "debugpy-adapter" })
			end
		end

		dap.configurations.python = {
			{
				type = "python",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				console = "integratedTerminal",
				pythonPath = python_path,
			},
			{
				type = "python",
				request = "attach",
				name = "Attach (127.0.0.1:5678)",
				connect = { host = "127.0.0.1", port = 5678 },
			},
		}
	end,
}
