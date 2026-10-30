vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-jdtls" },
})

local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"

-- java-debug and vscode-java-test plugins loaded into jdtls for DAP and tests.
local function bundles()
	local result = vim.fn.glob(
		mason_packages .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
		false,
		true
	)
	for _, jar in ipairs(vim.fn.glob(mason_packages .. "/java-test/extension/server/*.jar", false, true)) do
		local name = vim.fn.fnamemodify(jar, ":t")
		-- These two are not jdtls plugins and break it when bundled.
		if name ~= "com.microsoft.java.test.runner-jar-with-dependencies.jar" and name ~= "jacocoagent.jar" then
			table.insert(result, jar)
		end
	end
	return result
end

local function start_jdtls()
	local root = vim.fs.root(0, { "gradlew", "mvnw", "pom.xml", "build.gradle", "build.gradle.kts", ".git" })
		or vim.fn.getcwd()
	local cmd = { "jdtls" }
	local lombok = mason_packages .. "/jdtls/lombok.jar"
	if vim.uv.fs_stat(lombok) then
		table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok)
	end
	-- One workspace per project, keyed by its root path.
	vim.list_extend(cmd, { "-data", vim.fn.stdpath("cache") .. "/jdtls/" .. root:gsub("[/\\:]", "_") })

	require("jdtls").start_or_attach({
		cmd = cmd,
		root_dir = root,
		capabilities = require("blink.cmp").get_lsp_capabilities(),
		init_options = { bundles = bundles() },
		on_attach = function(_, buf)
			local jdtls = require("jdtls")
			jdtls.setup_dap({ hotcodereplace = "auto" })
			require("jdtls.dap").setup_dap_main_class_configs()
			vim.keymap.set("n", "<leader>tt", jdtls.test_class, { buffer = buf, desc = "Test class" })
			vim.keymap.set("n", "<leader>tr", jdtls.test_nearest_method, { buffer = buf, desc = "Test nearest method" })
		end,
	})
end

-- jdtls is started by nvim-jdtls rather than vim.lsp.enable, so it is a tool here.
return {
	tools = { "jdtls", "java-debug-adapter", "java-test" },
	parsers = { "java" },
	setup = function()
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("user_jdtls", { clear = true }),
			pattern = "java",
			callback = start_jdtls,
		})
	end,
}
