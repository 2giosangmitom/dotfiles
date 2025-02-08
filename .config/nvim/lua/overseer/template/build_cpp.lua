return {
  name = "Build C++",
  builder = function()
    local file_name = vim.fn.expand("%:p")
    local is_windows = vim.fn.has("win32") == 1
    local output_dir = vim.fn.getcwd() .. (is_windows and "\\bin" or "/bin")
    if not vim.uv.fs_stat(output_dir) then vim.fn.mkdir(output_dir, "p") end
    local output_file = output_dir .. (is_windows and "\\" or "/") .. vim.fn.fnamemodify(file_name, ":t:r")

    return {
      cmd = { "clang++" },
      args = {
        "-g",
        "-Wall",
        "-Wextra",
        "-Werror",
        "--std=c++23",
        file_name,
        "-o",
        output_file,
      },
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
