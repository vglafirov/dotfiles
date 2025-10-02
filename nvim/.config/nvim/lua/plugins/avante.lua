---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "go",
      "python",
      "ruby",
      "terraform",
      "yaml",
      -- add more arguments for adding more treesitter parsers
    },
  },
}
