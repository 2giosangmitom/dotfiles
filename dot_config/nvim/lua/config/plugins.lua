-- Load plugin modules; each handles its own installation and setup.
local files = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/plugins", "*.lua", false, true)

for _, file in ipairs(files) do
	local module = "plugins." .. vim.fn.fnamemodify(file, ":t:r")
	require(module)
end
