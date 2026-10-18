vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
})

require("plugins.blink-cmp")

vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
    },
  },
})

-- Language-server executables must be installed separately and available on PATH.
vim.lsp.enable("lua_ls")
