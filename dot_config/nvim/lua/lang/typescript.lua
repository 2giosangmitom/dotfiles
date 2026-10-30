-- JavaScript and TypeScript
local filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }

local function by_filetype(value)
	local result = {}
	for _, ft in ipairs(filetypes) do
		result[ft] = value
	end
	return result
end

return {
	servers = {
		vtsls = {
			settings = {
				vtsls = { autoUseWorkspaceTsdk = true },
				typescript = { updateImportsOnFileMove = { enabled = "always" } },
				javascript = { updateImportsOnFileMove = { enabled = "always" } },
			},
		},
	},
	tools = { "oxfmt", "oxlint", "js-debug-adapter" },
	parsers = { "javascript", "typescript", "tsx", "jsdoc" },
	formatters = by_filetype({ "oxfmt" }),
	linters = by_filetype({ "oxlint" }),
	dap = function(dap)
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
	end,
}
