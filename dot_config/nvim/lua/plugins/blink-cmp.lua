vim.pack.add({
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
})

require("blink.cmp").setup({
  keymap = { preset = "super-tab" },
  fuzzy = { implementation = "lua" },
})
