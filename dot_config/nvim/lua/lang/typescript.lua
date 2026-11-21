--- JavaScript and TypeScript.
local filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }

--- Map every JS/TS filetype to the same value.
---@generic T
---@param value T
---@return table<string, T>
local function by_filetype(value)
	local result = {}
	for _, ft in ipairs(filetypes) do
		result[ft] = value
	end
	return result
end

---@type config.LangSpec
return {
	servers = { "vtsls" },
	parsers = { "javascript", "typescript", "tsx", "jsdoc" },
	formatters = by_filetype({ "oxfmt" }),
	linters = by_filetype({ "oxlint" }),
	dap = function(dap)
		-- js-debug ships a Node script, not an executable.
		local js_debug = require("config.mise").where("github:microsoft/vscode-js-debug")
		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = { (js_debug or "") .. "/src/dapDebugServer.js", "${port}" },
			},
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
	end,
}
