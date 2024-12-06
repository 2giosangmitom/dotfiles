return {
  name = "Build C++",
  builder = function()
    local file_name = vim.fn.expand("%:p")
    local output_dir = vim.fn.getcwd() .. "/bin"
    vim.fn.mkdir(output_dir, "p")
    return {
      cmd = { "clang++" },
      args = {
        "-g",
        "-Wall",
        "-Wextra",
        "--std=c++23",
        file_name,
        "-o",
        output_dir .. "/" .. vim.fn.fnamemodify(file_name, ":t:r"),
      },
      components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  condition = {
    filetype = { "cpp" },
  },
}
