--- Loading helpers built on `MiniMisc.safely()`.
--- Each helper runs a callback at the appropriate time and reports any error
--- as a warning instead of aborting startup.

vim.pack.add({ { src = "https://github.com/nvim-mini/mini.misc" } })

local safely = require("mini.misc").safely

---@alias config.Callback fun()

--- Each function is documented where it is defined.
---@class config.Loader
local Config = {}

--- Run `f` immediately. Use for what must exist during startup.
---@param f config.Callback
function Config.now(f)
	safely("now", f)
end

--- Run `f` shortly after startup. Use for anything not needed immediately.
---@param f config.Callback
function Config.later(f)
	safely("later", f)
end

--- Run `f` once on the first occurrence of an event.
---@param ev string Event name(s), e.g. `"InsertEnter"`.
---@param f config.Callback
function Config.on_event(ev, f)
	safely("event:" .. ev, f)
end

--- Run `f` once when a matching filetype is first set.
---@param ft string Filetype(s), e.g. `"lua"`.
---@param f config.Callback
function Config.on_filetype(ft, f)
	safely("filetype:" .. ft, f)
end

--- Run `f` immediately when files were passed on the command line, else later.
---@type fun(f: config.Callback)
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later

local local_dir = vim.fn.expand("~/Workspace")

--- Whether a local plugin checkout exists in ~/Workspace.
---@param name string Directory name, e.g. `"nightfall.nvim"`.
---@return boolean
function Config.has_local(name)
	return vim.uv.fs_stat(vim.fs.joinpath(local_dir, name)) ~= nil
end

--- Add a local plugin checkout from ~/Workspace to 'runtimepath', if it exists.
---@param name string
---@return boolean added
function Config.add_local(name)
	if not Config.has_local(name) then
		return false
	end
	vim.opt.rtp:prepend(vim.fs.joinpath(local_dir, name))
	return true
end

---@type config.Loader
_G.Config = Config
