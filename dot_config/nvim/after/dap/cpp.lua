local dap = require("dap")

dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = { command = "codelldb", args = { "--port", "${port}" } },
}

local configurations = {
	{
		type = "codelldb",
		request = "launch",
		name = "Launch executable",
		program = function()
			return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
	},
	{
		type = "codelldb",
		request = "attach",
		name = "Attach to process",
		pid = require("dap.utils").pick_process,
		cwd = "${workspaceFolder}",
	},
}
dap.configurations.c = configurations
dap.configurations.cpp = configurations
