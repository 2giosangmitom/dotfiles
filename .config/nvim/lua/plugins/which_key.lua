return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = {
    "echasnovski/mini.icons",
  },
  opts = {
    preset = "helix",
    spec = {
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>s", group = "search" },
      { "<leader>u", group = "ui" },
      { "<leader>f", group = "find/file" },
      { "<leader>g", group = "git" },
      { "<leader>p", group = "packages", icon = { icon = "", color = "orange" } },
      { "<leader>o", group = "overseer", icon = { icon = "", color = "blue" } },
      { "<leader>x", group = "quickfix/diagnostic" },
    },
  },
  keys = {
    {
      "<leader>?",
      function() require("which-key").show({ global = false }) end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
