local dap = require("dap")

local filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }

dap.adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = { command = "js-debug-adapter", args = { "${port}" } },
}
-- Alias so launch.json files using type "node" work too.
dap.adapters.node = function(callback, config)
	config.type = "pwa-node"
	callback(dap.adapters["pwa-node"])
end

for _, ft in ipairs(filetypes) do
	dap.configurations[ft] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach to process",
			processId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
		},
	}
end
