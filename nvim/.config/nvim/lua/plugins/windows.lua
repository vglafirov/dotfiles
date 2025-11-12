return {
  {
    "anuvyklack/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    opts = {
      autowidth = {
        enable = true,
        winwidth = 5, -- minimum width
      },
      ignore = {
        buftype = { "quickfix" },
        filetype = { "NvimTree", "neo-tree", "undotree", "gundo" },
      },
      animation = {
        enable = true,
        duration = 150,
      },
    },

    keys = {
      { "<leader>wm", "<cmd>WindowsMaximize<cr>", desc = "Maximize Window" },
      { "<leader>w_", "<cmd>WindowsMaximizeVertically<cr>", desc = "Maximize Vertically" },
      { "<leader>w|", "<cmd>WindowsMaximizeHorizontally<cr>", desc = "Maximize Horizontally" },
      { "<leader>w=", "<cmd>WindowsEqualize<cr>", desc = "Equalize Windows" },
    },
  },
}
