return {
  name = "Build single C++ file",
  builder = function()
    local file = vim.fn.expand("%:p")
    local file_we = vim.fn.expand("%:t:r")
    local dir = vim.uv.cwd() .. "/bin"
    if not vim.uv.fs_stat(dir) then vim.fn.mkdir(dir) end

    return {
      cmd = { "clang++" },
      args = { file, "-g", "-std=c++17", "-fsanitize=address", "-fno-omit-frame-pointer", "-o", dir .. "/" .. file_we },
      components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  condition = {
    filetype = { "cpp" },
  },
}
