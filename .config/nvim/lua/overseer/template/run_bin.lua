return {
  name = "Run binary",
  builder = function()
    local file_name = vim.fn.expand("%:p")
    local is_windows = vim.fn.has("win32") == 1
    local output_dir = vim.fn.getcwd() .. (is_windows and "\\bin" or "/bin")
    local executable_name = output_dir .. (is_windows and "\\" or "/") .. vim.fn.fnamemodify(file_name, ":t:r")
    local cmd, args

    if is_windows then
      cmd = { "cmd.exe" }
      args = { "/c", executable_name }
    else
      cmd = { vim.env.SHELL }
      args = { "-c", executable_name }
    end

    return {
      cmd = cmd,
      args = args,
      components = {
        { "on_output_quickfix", open = false, set_diagnostics = true },
        "on_result_diagnostics",
        "default",
      },
    }
  end,
  condition = {
    filetype = { "cpp" },
  },
}
