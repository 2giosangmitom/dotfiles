vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/igorlfs/nvim-dap-view" },
})

local dap = require("dap")
local dap_view = require("dap-view")
local icons = require("config.icons").dap

-- Open the view when a session starts and close it when the session ends.
dap_view.setup({ auto_toggle = true })

for _, spec in ipairs(require("config.lang").specs()) do
	if spec.dap then
		spec.dap(dap)
	end
end

vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
local signs = {
	DapBreakpoint = { icons.Breakpoint, "DiagnosticError" },
	DapBreakpointCondition = { icons.BreakpointCondition, "DiagnosticWarn" },
	DapBreakpointRejected = { icons.BreakpointRejected, "DiagnosticError" },
	DapLogPoint = { icons.LogPoint, "DiagnosticInfo" },
	DapStopped = { icons.Stopped, "DiagnosticWarn", "DapStoppedLine" },
}
for name, sign in pairs(signs) do
	vim.fn.sign_define(name, { text = sign[1], texthl = sign[2], linehl = sign[3], numhl = sign[3] })
end

local map = vim.keymap.set
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
map("n", "<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Conditional breakpoint" })
map("n", "<leader>dc", dap.continue, { desc = "Run/Continue" })
map("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to cursor" })
map("n", "<leader>dl", dap.run_last, { desc = "Run last" })
map("n", "<leader>di", dap.step_into, { desc = "Step into" })
map("n", "<leader>do", dap.step_out, { desc = "Step out" })
map("n", "<leader>dO", dap.step_over, { desc = "Step over" })
map("n", "<leader>dP", dap.pause, { desc = "Pause" })
map("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
map("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
map("n", "<leader>du", function()
	dap_view.toggle()
end, { desc = "Toggle DAP view" })
map({ "n", "x" }, "<leader>de", function()
	dap_view.hover()
end, { desc = "Evaluate expression" })
map({ "n", "x" }, "<leader>dw", function()
	dap_view.add_expr()
end, { desc = "Watch expression" })
