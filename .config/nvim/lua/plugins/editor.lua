return {
  {
    "Saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab",
      },
    },
  },
  {
    "echasnovski/mini.trailspace",
    event = "VeryLazy",
    opts = {},
  },
  {
    "echasnovski/mini.visits",
    keys = {
      { "<leader>vp", "<cmd>lua MiniVisits.select_path()<cr>", desc = "Select path" },
      { "<leader>vl", "<cmd>lua MiniVisits.select_label()<cr>", desc = "Select label" },
      { "<leader>va", "<cmd>lua MiniVisits.add_label()<cr>", desc = "Add label" },
      { "<leader>vd", "<cmd>lua MiniVisits.remove_label()<cr>", desc = "Delete label" },
    },
    opts = {},
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        {
          mode = { "n" },
          { "<leader>v", group = "visits" },
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>fp",
        function()
          Snacks.picker.projects({
            dev = { "~/Workspace" },
            recent = false,
          })
        end,
        desc = "Projects",
      },
    },
  },
}
