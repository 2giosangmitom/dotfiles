--- Minimal vim.pack dashboard, opened with :Pack.
--- Lists installed plugins and can update, check for new commits, clean,
--- delete and inspect them from a floating window.

local api = vim.api

local ns = api.nvim_create_namespace("pack_ui")

--- Commits shown in the details before the list is truncated.
local MAX_COMMITS_PREVIEW = 10

--- Frames of the spinner shown while checking for updates.
local SPINNER = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

local get_icon = require("config.icons").get

local ICONS = {
	loaded = get_icon("PluginLoaded"),
	inactive = get_icon("PluginInactive"),
	update = get_icon("PluginUpdate"),
	breaking = get_icon("PluginBreaking"),
	current = get_icon("Check"),
	arrow = get_icon("ArrowRight"),
	expanded = get_icon("FoldOpened"),
	collapsed = get_icon("FoldClosed"),
}

--- Footer key hints: key, description.
---@type [string, string][]
local HINTS = {
	{ "U", "update all" },
	{ "u", "update" },
	{ "C", "check" },
	{ "X", "clean" },
	{ "D", "delete" },
	{ "L", "log" },
	{ "?", "help" },
	{ "q", "close" },
}

--- Full key list shown with `?`.
---@type [string, string][]
local HELP = {
	{ "U", "Update all plugins" },
	{ "u", "Update the plugin under the cursor" },
	{ "C", "Check remotes for new commits" },
	{ "X", "Clean (remove) every inactive plugin" },
	{ "D", "Delete the inactive plugin under the cursor" },
	{ "L", "Open the vim.pack log" },
	{ "gx", "Open the plugin's repository" },
	{ "<CR>", "Toggle details (again to show every commit)" },
	{ "]] [[", "Next / previous plugin" },
	{ "q <Esc>", "Close" },
}

--- Link the UI highlight groups to standard ones, unless already defined.
local function setup_highlights()
	local links = {
		PackUiTitle = "FloatTitle",
		PackUiFooter = "FloatFooter",
		PackUiKey = "Special",
		PackUiSummary = "Comment",
		PackUiSection = "Title",
		PackUiCount = "Comment",
		PackUiLoaded = "DiagnosticOk",
		PackUiInactive = "Comment",
		PackUiName = "Normal",
		PackUiVersion = "Number",
		PackUiUpdate = "DiagnosticInfo",
		PackUiBreaking = "DiagnosticWarn",
		PackUiCurrent = "DiagnosticOk",
		PackUiSpinner = "DiagnosticInfo",
		PackUiLabel = "Label",
		PackUiDetail = "Comment",
		PackUiHash = "Identifier",
		PackUiGuide = "NonText",
	}
	for group, target in pairs(links) do
		api.nvim_set_hl(0, group, { link = target, default = true })
	end
end

---@class pack_ui.CheckResult
---@field name string
---@field updates? string[] New commits (`git log --oneline` lines)
---@field breaking? boolean Major version bump or a breaking commit
---@field unreleased_breaking? string[] Breaking commits not released yet
---@field latest_ref? string Latest tag or commit hash

---@class pack_ui.State
---@field bufnr? integer
---@field winid? integer
---@field augroup? integer
---@field timer? uv.uv_timer_t Spinner timer while checking
---@field spinner integer Current spinner frame
---@field line_to_plugin table<integer, string> 1-based line => plugin name
---@field plugin_lines table<string, integer> Plugin name => 1-based line
---@field expanded table<string, boolean>
---@field show_all_commits table<string, boolean>
---@field show_help boolean
---@field updates table<string, string[]>
---@field breaking table<string, boolean>
---@field unreleased_breaking table<string, string[]>
---@field latest_ref table<string, string>
---@field checked boolean A check has finished since the window was opened
---@field checking boolean
---@field check_id integer Bumped on each check and on close, to drop stale results

---@type pack_ui.State
local state = {
	spinner = 1,
	line_to_plugin = {},
	plugin_lines = {},
	expanded = {},
	show_all_commits = {},
	show_help = false,
	updates = {},
	breaking = {},
	unreleased_breaking = {},
	latest_ref = {},
	checked = false,
	checking = false,
	check_id = 0,
}

--- Installed git tag per plugin path (`false` when HEAD is not tagged).
---@type table<string, string|false>
local tag_cache = {}

--- Remote default branch per plugin path (`false` when it can't be resolved).
---@type table<string, string|false>
local ref_cache = {}

--- Forward declaration: the update check re-renders when it progresses.
---@type fun()
local render

-- Git helpers

--- Exact tag of the installed commit, cached for the session.
---@param path string
---@return string?
local function get_installed_tag(path)
	if tag_cache[path] == nil then
		local result = vim.system({ "git", "-C", path, "describe", "--tags", "--exact-match", "HEAD" }, { text = true })
			:wait()
		tag_cache[path] = result.code == 0 and vim.trim(result.stdout) or false
	end
	return tag_cache[path] or nil
end

--- Parse `vX.Y.Z` or `X.Y.Z` (with any suffix) into its numbers.
---@param tag string?
---@return integer[]?
local function parse_semver(tag)
	local major, minor, patch = (tag or ""):match("^v?(%d+)%.(%d+)%.(%d+)")
	if major then
		return { tonumber(major), tonumber(minor), tonumber(patch) }
	end
end

--- Whether version `a` is strictly greater than `b`.
---@param a integer[]?
---@param b integer[]?
---@return boolean
local function semver_gt(a, b)
	if not a or not b then
		return false
	end
	for i = 1, 3 do
		if a[i] ~= b[i] then
			return a[i] > b[i]
		end
	end
	return false
end

--- Whether a `git log --oneline` line is a conventional breaking commit
--- (`type!:` or `type(scope)!:`).
---@param commit string
---@return boolean
local function is_breaking_commit(commit)
	return commit:match("^%x+ %w+!:") ~= nil or commit:match("^%x+ %w+%b()!:") ~= nil
end

--- Run `git log --oneline <range>` asynchronously.
---@param path string
---@param range string
---@param callback fun(commits: string[])
local function git_log(path, range, callback)
	vim.system({ "git", "-C", path, "log", "--oneline", range }, { text = true }, function(res)
		callback(res.code == 0 and vim.split(res.stdout, "\n", { trimempty = true }) or {})
	end)
end

--- Resolve the remote default branch (origin/HEAD, then origin/main, then
--- origin/master), cached for the session.
---@param path string
---@param callback fun(ref: string?)
local function resolve_remote_ref(path, callback)
	if ref_cache[path] ~= nil then
		return callback(ref_cache[path] or nil)
	end
	local candidates = {
		{ { "symbolic-ref", "refs/remotes/origin/HEAD" } },
		{ { "rev-parse", "--verify", "origin/main" }, "origin/main" },
		{ { "rev-parse", "--verify", "origin/master" }, "origin/master" },
	}
	local function try(i)
		local candidate = candidates[i]
		if not candidate then
			ref_cache[path] = false
			return callback(nil)
		end
		local cmd = vim.list_extend({ "git", "-C", path }, candidate[1])
		vim.system(cmd, { text = true }, function(res)
			if res.code ~= 0 then
				return try(i + 1)
			end
			local ref = candidate[2] or vim.trim(res.stdout)
			ref_cache[path] = ref
			callback(ref)
		end)
	end
	try(1)
end

-- Update check

--- Check a plugin pinned to a version: compare against the newest tag, then
--- look for breaking commits on the default branch that are not released yet.
---@param path string
---@param result pack_ui.CheckResult
---@param current_tag string
---@param finish fun(result: pack_ui.CheckResult?)
local function check_versioned(path, result, current_tag, finish)
	vim.system({ "git", "-C", path, "tag", "--list" }, { text = true }, function(tag_res)
		local current = parse_semver(current_tag)
		local latest_tag, latest
		for tag in (tag_res.code == 0 and tag_res.stdout or ""):gmatch("[^\n]+") do
			local version = parse_semver(tag)
			if version and (not latest or semver_gt(version, latest)) then
				latest_tag, latest = tag, version
			end
		end
		if current and latest and latest[1] > current[1] then
			result.breaking = true
		end

		local function check_unreleased()
			resolve_remote_ref(path, function(ref)
				if not ref then
					return finish(result)
				end
				git_log(path, (latest_tag or current_tag) .. ".." .. ref, function(unreleased)
					local breaking = vim.tbl_filter(is_breaking_commit, unreleased)
					if #breaking > 0 then
						result.unreleased_breaking = breaking
					end
					finish(result)
				end)
			end)
		end

		if latest_tag and semver_gt(latest, current) then
			result.latest_ref = latest_tag
			git_log(path, "HEAD.." .. latest_tag, function(commits)
				result.updates = commits
				result.breaking = result.breaking or vim.iter(commits):any(is_breaking_commit)
				check_unreleased()
			end)
		else
			result.updates = {}
			check_unreleased()
		end
	end)
end

--- Check a plugin that follows a branch: compare against the default branch.
---@param path string
---@param result pack_ui.CheckResult
---@param finish fun(result: pack_ui.CheckResult?)
local function check_branch(path, result, finish)
	resolve_remote_ref(path, function(ref)
		if not ref then
			return finish(nil)
		end
		git_log(path, "HEAD.." .. ref, function(commits)
			result.updates = commits
			result.breaking = vim.iter(commits):any(is_breaking_commit)
			result.latest_ref = commits[1] and commits[1]:match("^(%x+)")
			finish(result)
		end)
	end)
end

--- Stop the spinner timer, if running.
local function stop_spinner()
	if state.timer then
		state.timer:stop()
		state.timer:close()
		state.timer = nil
	end
end

--- Animate the spinner in the summary line until the check finishes.
local function start_spinner()
	stop_spinner()
	state.timer = vim.uv.new_timer()
	state.timer:start(
		80,
		80,
		vim.schedule_wrap(function()
			state.spinner = state.spinner % #SPINNER + 1
			render()
		end)
	)
end

--- Fetch every plugin and look for new commits and releases.
local function check_updates()
	local plugins = vim.pack.get(nil, { info = false })
	if state.checking or #plugins == 0 then
		return
	end

	state.check_id = state.check_id + 1
	local check_id = state.check_id
	state.checking = true
	state.updates, state.breaking, state.unreleased_breaking, state.latest_ref = {}, {}, {}, {}
	start_spinner()
	render()

	local remaining = #plugins

	--- Store one plugin's result on the main loop. Results of a check that was
	--- cancelled by closing the window are dropped.
	---@param result pack_ui.CheckResult?
	local function finish(result)
		vim.schedule(function()
			if state.check_id ~= check_id then
				return
			end
			if result then
				local name = result.name
				state.updates[name] = result.updates
				state.breaking[name] = result.breaking or nil
				state.unreleased_breaking[name] = result.unreleased_breaking
				state.latest_ref[name] = result.latest_ref
			end
			remaining = remaining - 1
			if remaining == 0 then
				state.checking = false
				state.checked = true
				stop_spinner()
				render()
			end
		end)
	end

	for _, p in ipairs(plugins) do
		local path = p.path
		local current_tag = p.spec.version and get_installed_tag(path)
		vim.system({ "git", "-C", path, "fetch", "--quiet", "--tags" }, {}, function(fetch)
			if fetch.code ~= 0 then
				return finish(nil)
			end
			local result = { name = p.spec.name }
			if current_tag then
				check_versioned(path, result, current_tag, finish)
			else
				check_branch(path, result, finish)
			end
		end)
	end
end

-- Rendering

---@alias pack_ui.Chunk [string, string?] Text and optional highlight group

---@class pack_ui.Builder
---@field lines string[]
---@field marks [integer, integer, integer, string][] Line, start col, end col, group

--- Pad text with spaces to a display width.
---@param text string
---@param width integer
---@return string
local function pad(text, width)
	return text .. string.rep(" ", width - vim.fn.strdisplaywidth(text))
end

--- Append a line made of highlighted chunks.
---@param b pack_ui.Builder
---@param chunks pack_ui.Chunk[]
---@return integer lnum 1-based line number
local function add(b, chunks)
	local text = ""
	for _, chunk in ipairs(chunks) do
		if chunk[2] and chunk[1] ~= "" then
			table.insert(b.marks, { #b.lines, #text, #text + #chunk[1], chunk[2] })
		end
		text = text .. chunk[1]
	end
	table.insert(b.lines, text)
	return #b.lines
end

--- Installed version shown for a plugin: its tag, short commit or spec version.
---@param p vim.pack.PlugData
---@return string
local function installed_version(p)
	local tag = p.spec.version and get_installed_tag(p.path)
	if tag then
		return tag
	end
	if p.rev then
		return p.rev:sub(1, 7)
	end
	return p.spec.version and tostring(p.spec.version) or ""
end

--- Status chunks of a plugin after a check: updates, target and breaking marks.
---@param name string
---@param version string Installed version, to skip a target that equals it
---@return pack_ui.Chunk[]
local function status_chunks(name, version)
	local chunks = {}
	local count = #(state.updates[name] or {})
	local breaking = state.breaking[name]
	if count > 0 then
		local hl = breaking and "PackUiBreaking" or "PackUiUpdate"
		table.insert(chunks, { ICONS.update .. count, hl })
		local latest = state.latest_ref[name]
		-- Ignore a `v` prefix difference between the installed and latest tag.
		if latest and latest:gsub("^v", "") ~= version:gsub("^v", "") then
			table.insert(chunks, { " " .. ICONS.arrow .. " " .. latest, hl })
		end
		if breaking then
			table.insert(chunks, { " " .. ICONS.breaking .. " breaking", "PackUiBreaking" })
		end
	elseif state.checked and state.updates[name] then
		table.insert(chunks, { ICONS.current, "PackUiCurrent" })
	end
	local unreleased = state.unreleased_breaking[name]
	if unreleased then
		local text = ("  %s %d unreleased breaking"):format(ICONS.breaking, #unreleased)
		table.insert(chunks, { text, "PackUiBreaking" })
	end
	return chunks
end

--- Append the expanded details of a plugin.
---@param b pack_ui.Builder
---@param p vim.pack.PlugData
local function add_details(b, p)
	local name = p.spec.name
	local guide = { "     │ ", "PackUiGuide" }
	---@param chunks pack_ui.Chunk[]
	local function detail(chunks)
		state.line_to_plugin[add(b, vim.list_extend({ guide }, chunks))] = name
	end

	detail({ { "Source  ", "PackUiLabel" }, { p.spec.src, "PackUiDetail" } })
	detail({ { "Path    ", "PackUiLabel" }, { p.path, "PackUiDetail" } })
	if p.rev then
		detail({ { "Rev     ", "PackUiLabel" }, { p.rev, "PackUiDetail" } })
	end

	local commits = state.updates[name] or {}
	if #commits > 0 then
		detail({ { ("New commits (%d)"):format(#commits), "PackUiLabel" } })
		local limit = state.show_all_commits[name] and #commits or MAX_COMMITS_PREVIEW
		for i = 1, math.min(limit, #commits) do
			local hash, message = commits[i]:match("^(%x+) (.*)$")
			local hl = is_breaking_commit(commits[i]) and "PackUiBreaking" or nil
			detail({ { "  " .. (hash or ""), "PackUiHash" }, { " " .. (message or commits[i]), hl } })
		end
		if #commits > limit then
			detail({ { ("  … %d more, <CR> to show all"):format(#commits - limit), "PackUiDetail" } })
		end
	end

	local unreleased = state.unreleased_breaking[name] or {}
	if #unreleased > 0 then
		detail({ { ICONS.breaking .. " Unreleased breaking changes", "PackUiBreaking" } })
		for _, commit in ipairs(unreleased) do
			local hash, message = commit:match("^(%x+) (.*)$")
			detail({ { "  " .. (hash or ""), "PackUiHash" }, { " " .. (message or commit), "PackUiBreaking" } })
		end
	end
end

--- Summary line: plugin counts, or the check progress.
---@param plugins vim.pack.PlugData[]
---@param loaded integer
---@return pack_ui.Chunk[]
local function summary_chunks(plugins, loaded)
	local chunks = {
		{ " " },
		{ tostring(#plugins), "PackUiName" },
		{ " plugins  ", "PackUiSummary" },
		{ ICONS.loaded .. " " .. loaded, "PackUiLoaded" },
		{ " loaded  ", "PackUiSummary" },
		{ ICONS.inactive .. " " .. (#plugins - loaded), "PackUiInactive" },
		{ " inactive", "PackUiSummary" },
	}
	if state.checking then
		vim.list_extend(
			chunks,
			{ { "   " }, { SPINNER[state.spinner] .. " checking for updates…", "PackUiSpinner" } }
		)
	elseif state.checked then
		local outdated = vim.tbl_count(vim.tbl_filter(function(c)
			return #c > 0
		end, state.updates))
		if outdated == 0 then
			vim.list_extend(chunks, { { "   " }, { ICONS.current .. " all up to date", "PackUiCurrent" } })
		else
			vim.list_extend(chunks, { { "   " }, { ICONS.update .. " " .. outdated .. " outdated", "PackUiUpdate" } })
			local breaking = vim.tbl_count(state.breaking)
			if breaking > 0 then
				table.insert(chunks, { "  " .. ICONS.breaking .. " " .. breaking .. " breaking", "PackUiBreaking" })
			end
		end
	end
	return chunks
end

--- Build the buffer lines and highlights from the current state.
---@return pack_ui.Builder
local function build()
	local plugins = vim.pack.get(nil, { info = false })
	table.sort(plugins, function(a, b)
		return a.spec.name < b.spec.name
	end)
	local loaded = vim.tbl_filter(function(p)
		return p.active
	end, plugins)
	local inactive = vim.tbl_filter(function(p)
		return not p.active
	end, plugins)

	---@type pack_ui.Builder
	local b = { lines = {}, marks = {} }
	state.line_to_plugin, state.plugin_lines = {}, {}

	add(b, summary_chunks(plugins, #loaded))

	if state.show_help then
		add(b, {})
		for _, item in ipairs(HELP) do
			add(b, { { "   " .. pad(item[1], 9), "PackUiKey" }, { item[2], "PackUiDetail" } })
		end
	end

	-- Column widths, so versions and statuses line up.
	local name_width, version_width = 0, 0
	for _, p in ipairs(plugins) do
		name_width = math.max(name_width, vim.fn.strdisplaywidth(p.spec.name))
		version_width = math.max(version_width, vim.fn.strdisplaywidth(installed_version(p)))
	end

	---@param title string
	---@param list vim.pack.PlugData[]
	---@param icon string
	---@param hl string
	local function section(title, list, icon, hl)
		if #list == 0 then
			return
		end
		add(b, {})
		add(b, { { " " .. title, "PackUiSection" }, { " " .. #list, "PackUiCount" } })
		for _, p in ipairs(list) do
			local name = p.spec.name
			local version = installed_version(p)
			local fold = state.expanded[name] and ICONS.expanded or ICONS.collapsed
			local chunks = {
				{ " " .. fold .. " ", "PackUiGuide" },
				{ icon, hl },
				{ " " .. pad(name, name_width) .. "  ", p.active and "PackUiName" or "PackUiInactive" },
				{ pad(version, version_width) .. "  ", "PackUiVersion" },
			}
			local lnum = add(b, vim.list_extend(chunks, status_chunks(name, version)))
			state.line_to_plugin[lnum] = name
			state.plugin_lines[name] = lnum
			if state.expanded[name] then
				add_details(b, p)
			end
		end
	end

	section("Loaded", loaded, ICONS.loaded, "PackUiLoaded")
	section("Inactive", inactive, ICONS.inactive, "PackUiInactive")
	return b
end

render = function()
	if not state.bufnr or not api.nvim_buf_is_valid(state.bufnr) then
		return
	end
	local b = build()
	vim.bo[state.bufnr].modifiable = true
	api.nvim_buf_set_lines(state.bufnr, 0, -1, false, b.lines)
	vim.bo[state.bufnr].modifiable = false
	vim.bo[state.bufnr].modified = false
	api.nvim_buf_clear_namespace(state.bufnr, ns, 0, -1)
	for _, mark in ipairs(b.marks) do
		api.nvim_buf_set_extmark(state.bufnr, ns, mark[1], mark[2], { end_col = mark[3], hl_group = mark[4] })
	end
end

-- Window

--- Footer with the key hints, as highlighted chunks.
---@return [string, string][]
local function footer()
	local chunks = { { " ", "PackUiFooter" } }
	for i, hint in ipairs(HINTS) do
		table.insert(chunks, { hint[1], "PackUiKey" })
		table.insert(chunks, { " " .. hint[2] .. (i < #HINTS and " · " or " "), "PackUiFooter" })
	end
	return chunks
end

--- Centered float covering most of the editor. The border follows 'winborder'.
---@return vim.api.keyset.win_config
local function win_config()
	local columns, lines = vim.o.columns, vim.o.lines
	local width = math.min(columns - 4, math.max(math.floor(columns * 0.8), 80))
	local height = math.min(lines - 4, math.max(math.floor(lines * 0.7), 20))
	return {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((lines - height) / 2),
		col = math.floor((columns - width) / 2),
		style = "minimal",
		border = vim.o.winborder ~= "" and vim.o.winborder or "single",
		title = { { " vim.pack ", "PackUiTitle" } },
		title_pos = "center",
		footer = footer(),
		footer_pos = "center",
	}
end

--- Name of the plugin on the cursor line, or in the details under it.
---@return string?
local function plugin_at_cursor()
	if state.winid and api.nvim_win_is_valid(state.winid) then
		return state.line_to_plugin[api.nvim_win_get_cursor(state.winid)[1]]
	end
end

--- Move the cursor to a plugin's line.
---@param name string
local function focus_plugin(name)
	local lnum = state.plugin_lines[name]
	if lnum and state.winid and api.nvim_win_is_valid(state.winid) then
		api.nvim_win_set_cursor(state.winid, { lnum, 0 })
	end
end

--- Reset the state of a closed window and cancel a running check.
local function reset_state()
	stop_spinner()
	if state.augroup then
		pcall(api.nvim_del_augroup_by_id, state.augroup)
	end
	state.winid, state.bufnr, state.augroup = nil, nil, nil
	state.expanded, state.show_all_commits, state.show_help = {}, {}, false
	state.updates, state.breaking, state.unreleased_breaking, state.latest_ref = {}, {}, {}, {}
	state.checked, state.checking = false, false
	state.check_id = state.check_id + 1
end

--- Close the window. The buffer is wiped with it ('bufhidden' is "wipe").
local function close()
	local winid = state.winid
	reset_state()
	if winid and api.nvim_win_is_valid(winid) then
		api.nvim_win_close(winid, true)
	end
end

--- Jump to the next or previous plugin line, wrapping around.
---@param direction 1|-1
local function jump_plugin(direction)
	if not state.winid or not api.nvim_win_is_valid(state.winid) then
		return
	end
	local row = api.nvim_win_get_cursor(state.winid)[1]
	local lnums = vim.tbl_values(state.plugin_lines)
	table.sort(lnums)
	if #lnums == 0 then
		return
	end
	local target = direction > 0 and lnums[1] or lnums[#lnums]
	for i = 1, #lnums do
		local lnum = direction > 0 and lnums[i] or lnums[#lnums + 1 - i]
		if (direction > 0 and lnum > row) or (direction < 0 and lnum < row) then
			target = lnum
			break
		end
	end
	api.nvim_win_set_cursor(state.winid, { target, 0 })
end

--- Remove plugins with vim.pack.del, after a confirmation prompt.
---@param names string[]
---@param prompt string
local function delete_plugins(names, prompt)
	if vim.fn.confirm(prompt, "&Yes\n&No", 2, "Question") ~= 1 then
		return
	end
	close()
	local ok, err = pcall(vim.pack.del, names)
	if ok then
		vim.notify(("vim.pack: removed %s"):format(table.concat(names, ", ")), vim.log.levels.INFO)
	else
		vim.notify("vim.pack: " .. tostring(err), vim.log.levels.ERROR)
	end
end

--- Buffer-local keymaps of the dashboard.
local function set_keymaps()
	---@param lhs string
	---@param rhs function
	---@param desc string
	local function map(lhs, rhs, desc)
		vim.keymap.set("n", lhs, rhs, { buffer = state.bufnr, silent = true, nowait = true, desc = desc })
	end

	map("q", close, "Close")
	map("<Esc>", close, "Close")

	map("U", function()
		close()
		vim.pack.update()
	end, "Update all plugins")

	map("u", function()
		local name = plugin_at_cursor()
		if name then
			close()
			vim.pack.update({ name })
		end
	end, "Update plugin")

	map("C", check_updates, "Check for updates")

	map("X", function()
		local inactive = vim.iter(vim.pack.get(nil, { info = false }))
			:filter(function(p)
				return not p.active
			end)
			:map(function(p)
				return p.spec.name
			end)
			:totable()
		if #inactive == 0 then
			return vim.notify("vim.pack: nothing to clean", vim.log.levels.INFO)
		end
		local prompt = ("Remove %d inactive plugin(s)?\n\n%s"):format(#inactive, table.concat(inactive, "\n"))
		delete_plugins(inactive, prompt)
	end, "Clean inactive plugins")

	map("D", function()
		local name = plugin_at_cursor()
		if not name then
			return
		end
		local ok, data = pcall(vim.pack.get, { name }, { info = false })
		if not ok or #data == 0 then
			return vim.notify(("vim.pack: %s is not installed"):format(name), vim.log.levels.WARN)
		end
		if data[1].active then
			return vim.notify(
				("vim.pack: %s is active, remove it from the config first"):format(name),
				vim.log.levels.WARN
			)
		end
		delete_plugins({ name }, ("Delete plugin %s?"):format(name))
	end, "Delete plugin")

	map("L", function()
		local log = vim.fs.joinpath(vim.fn.stdpath("log"), "nvim-pack.log")
		if not vim.uv.fs_stat(log) then
			return vim.notify("vim.pack: no log file yet", vim.log.levels.INFO)
		end
		close()
		vim.cmd.edit(log)
	end, "Open log")

	map("gx", function()
		local name = plugin_at_cursor()
		local data = name and vim.pack.get({ name }, { info = false })[1]
		if data then
			vim.ui.open((data.spec.src:gsub("%.git$", "")))
		end
	end, "Open repository")

	-- Cycle: collapsed, expanded, expanded with every commit (when truncated).
	map("<CR>", function()
		local name = plugin_at_cursor()
		if not name then
			return
		end
		local truncated = #(state.updates[name] or {}) > MAX_COMMITS_PREVIEW
		if not state.expanded[name] then
			state.expanded[name] = true
		elseif truncated and not state.show_all_commits[name] then
			state.show_all_commits[name] = true
		else
			state.expanded[name], state.show_all_commits[name] = nil, nil
		end
		render()
		focus_plugin(name)
	end, "Toggle details")

	map("]]", function()
		jump_plugin(1)
	end, "Next plugin")
	map("[[", function()
		jump_plugin(-1)
	end, "Previous plugin")

	map("?", function()
		local name = plugin_at_cursor()
		state.show_help = not state.show_help
		render()
		if name then
			focus_plugin(name)
		end
	end, "Toggle help")
end

--- Open the dashboard, or focus it if it is already open.
local function open()
	if state.winid and api.nvim_win_is_valid(state.winid) then
		return api.nvim_set_current_win(state.winid)
	end

	setup_highlights()

	state.bufnr = api.nvim_create_buf(false, true)
	vim.bo[state.bufnr].bufhidden = "wipe"
	vim.bo[state.bufnr].filetype = "pack-ui"

	local winid = api.nvim_open_win(state.bufnr, true, win_config())
	state.winid = winid
	vim.wo[winid].cursorline = true
	vim.wo[winid].wrap = false

	render()
	set_keymaps()

	-- Start on the first plugin.
	local first = math.huge
	for _, lnum in pairs(state.plugin_lines) do
		first = math.min(first, lnum)
	end
	if first < math.huge then
		api.nvim_win_set_cursor(winid, { first, 0 })
	end

	state.augroup = api.nvim_create_augroup("pack_ui", { clear = true })
	-- Clean up when the window is closed some other way (:quit, <C-w>c).
	api.nvim_create_autocmd("WinClosed", {
		group = state.augroup,
		pattern = tostring(winid),
		once = true,
		callback = reset_state,
	})
	-- Keep the window centered and sized to the editor.
	api.nvim_create_autocmd("VimResized", {
		group = state.augroup,
		callback = function()
			if api.nvim_win_is_valid(winid) then
				api.nvim_win_set_config(winid, win_config())
			end
		end,
	})
end

return { open = open, check_updates = check_updates }
