---@brief
--- Loading helpers built on `MiniMisc.safely()`.
---
--- Each helper runs a callback at the appropriate time and reports any error
--- as a warning instead of aborting startup.

vim.pack.add({ { src = "https://github.com/nvim-mini/mini.misc" } })

local safely = require("mini.misc").safely

---@alias config.Callback fun()

---@class config.Loader
---@field now fun(f: config.Callback) Run immediately.
---@field later fun(f: config.Callback) Run shortly after startup.
---@field on_event fun(ev: string, f: config.Callback) Run once on the first matching event.
---@field on_filetype fun(ft: string, f: config.Callback) Run once on the first matching filetype.
---@field now_if_args fun(f: config.Callback) `now` when Neovim starts with file arguments, otherwise `later`.

---@type config.Loader
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

---@type config.Loader
_G.Config = Config
