--- Java, via nvim-jdtls. jdtls is started by nvim-jdtls rather than
--- vim.lsp.enable, so it is not listed under `servers`. jdtls, lombok and the
--- java-debug/java-test bundles are installed by mise.
--- nvim-jdtls also registers the `java` debug adapter with nvim-dap,
--- discovers main classes when a debug session starts (:DapNew), and adds the
--- :Jdt* commands (:JdtUpdateConfig, :JdtRestart, :JdtBytecode, :JdtJshell...).
--- Generic LSP keymaps and features come from config/lsp.lua.
vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-jdtls" },
})

local mise = require("config.mise")

-- Build files take priority over .git, so a subproject in a monorepo is not
-- mistaken for the repository root.
local root_markers = {
	{ "mvnw", "gradlew", "settings.gradle", "settings.gradle.kts", "pom.xml", "build.gradle", "build.gradle.kts" },
	".git",
}

--- java-debug and vscode-java-test plugins loaded into jdtls for DAP and tests.
---@return string[] jars
local function bundles()
	local java_debug = mise.where("http:vscode-java-debug") or ""
	local java_test = mise.where("http:vscode-java-test") or ""
	local result = vim.fn.glob(java_debug .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", false, true)
	for _, jar in ipairs(vim.fn.glob(java_test .. "/extension/server/*.jar", false, true)) do
		local name = vim.fn.fnamemodify(jar, ":t")
		-- These are not jdtls plugins, or duplicate bundles jdtls already provides.
		if
			name ~= "com.microsoft.java.test.runner-jar-with-dependencies.jar"
			and name ~= "jacocoagent.jar"
			and not name:match("^org%.objectweb%.asm")
		then
			table.insert(result, jar)
		end
	end
	return result
end

--- Installed JDKs (system packages and SDKMAN), so projects targeting an older
--- Java version compile against the matching runtime. Switch with :JdtSetRuntime.
---@return { name: string, path: string, default?: boolean }[]
local function runtimes()
	local result, seen = {}, {}
	local dirs = vim.fn.glob("/usr/lib/jvm/java-*", false, true)
	vim.list_extend(dirs, vim.fn.glob(vim.fn.expand("~/.sdkman/candidates/java/*"), false, true))
	for _, dir in ipairs(dirs) do
		local version = vim.fn.fnamemodify(dir, ":t"):match("(%d+)")
		if version and not seen[version] and vim.uv.fs_stat(dir .. "/bin/java") then
			seen[version] = true
			table.insert(result, { name = "JavaSE-" .. version, path = dir })
		end
	end
	-- Default to the newest one.
	table.sort(result, function(a, b)
		return tonumber(a.name:match("%d+")) < tonumber(b.name:match("%d+"))
	end)
	if #result > 0 then
		result[#result].default = true
	end
	return result
end

local settings = {
	java = {
		eclipse = { downloadSources = true },
		maven = { downloadSources = true },
		configuration = {
			updateBuildConfiguration = "interactive",
			runtimes = runtimes(),
		},
		-- Decompile classes without sources when navigating into them.
		contentProvider = { preferred = "fernflower" },
		references = { includeDecompiledSources = true },
		referencesCodeLens = { enabled = true },
		implementationsCodeLens = { enabled = true },
		inlayHints = { parameterNames = { enabled = "literals" } },
		signatureHelp = { enabled = true, description = { enabled = true } },
		saveActions = { organizeImports = false }, -- Formatting is done by conform
		completion = {
			-- Suggest static imports for common test and utility members.
			favoriteStaticMembers = {
				"org.junit.jupiter.api.Assertions.*",
				"org.junit.jupiter.api.Assumptions.*",
				"org.assertj.core.api.Assertions.*",
				"org.mockito.Mockito.*",
				"org.mockito.ArgumentMatchers.*",
				"java.util.Objects.requireNonNull",
				"java.util.Objects.requireNonNullElse",
			},
			filteredTypes = { "com.sun.*", "io.micrometer.shaded.*", "java.awt.*", "jdk.*", "sun.*" },
			importOrder = { "java", "javax", "jakarta", "org", "com", "" },
		},
		sources = {
			organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
		},
		codeGeneration = {
			toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
			hashCodeEquals = { useJava7Objects = true },
			useBlocks = true,
		},
	},
}

--- Define Java-specific buffer-local keymaps.
---@param buf integer
local function set_keymaps(buf)
	local jdtls = require("jdtls")
	---@param mode string|string[]
	---@param lhs string
	---@param rhs string|function
	---@param desc string
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = "Java: " .. desc })
	end

	map("n", "<leader>cO", jdtls.organize_imports, "Organize imports")
	map("n", "<leader>cs", jdtls.super_implementation, "Go to super implementation")
	map("n", "<leader>cu", "<Cmd>JdtUpdateConfig<CR>", "Update project config")

	-- Refactoring. In Visual mode these act on the selection.
	map("n", "<leader>cxv", jdtls.extract_variable_all, "Extract variable")
	map("x", "<leader>cxv", function()
		jdtls.extract_variable_all({ visual = true })
	end, "Extract variable")
	map("n", "<leader>cxc", jdtls.extract_constant, "Extract constant")
	map("x", "<leader>cxc", function()
		jdtls.extract_constant({ visual = true })
	end, "Extract constant")
	map("x", "<leader>cxm", function()
		jdtls.extract_method({ visual = true })
	end, "Extract method")

	-- Tests (needs the java-test bundle). Runs under nvim-dap.
	map("n", "<leader>tt", jdtls.test_class, "Test class")
	map("n", "<leader>tr", jdtls.test_nearest_method, "Test nearest method")
	map("n", "<leader>tp", jdtls.pick_test, "Pick test")
	map("n", "<leader>tg", function()
		require("jdtls.tests").generate()
	end, "Generate tests")
	map("n", "<leader>ts", function()
		require("jdtls.tests").goto_subjects()
	end, "Go to test/subject")
end

--- Start jdtls for the project of a Java buffer, or attach to a running one.
---@param args vim.api.keyset.create_autocmd.callback_args
local function start_jdtls(args)
	local root = vim.fs.root(args.buf, root_markers) or vim.fn.getcwd()
	local cmd = { "jdtls" }
	local lombok = vim.fn.glob((mise.where("http:lombok") or "") .. "/lombok-*.jar", false, true)[1]
	if lombok then
		table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok)
	end
	-- One workspace per project, keyed by its root path. Kept in the data
	-- directory, since rebuilding the index is slow.
	vim.list_extend(cmd, { "-data", vim.fn.stdpath("data") .. "/jdtls-workspace/" .. root:gsub("[/\\:]", "_") })

	local jdtls = require("jdtls")
	local extended_capabilities = vim.deepcopy(jdtls.extendedClientCapabilities)
	-- Apply extra edits (e.g. auto-imports) after resolving a completion item.
	extended_capabilities.resolveAdditionalTextEditsSupport = true

	jdtls.start_or_attach({
		name = "jdtls",
		cmd = cmd,
		root_dir = root,
		capabilities = require("blink.cmp").get_lsp_capabilities(),
		settings = settings,
		init_options = {
			bundles = bundles(),
			extendedClientCapabilities = extended_capabilities,
		},
		on_attach = function(_, buf)
			set_keymaps(buf)
		end,
	}, {
		-- Passed to nvim-jdtls' automatic nvim-dap setup.
		dap = { hotcodereplace = "auto", config_overrides = {} },
	})
end

---@type config.LangSpec
return {
	parsers = { "java" },
	setup = function()
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("user_jdtls", { clear = true }),
			pattern = "java",
			callback = start_jdtls,
		})
	end,
}
