return {
  {
    "coffebar/neovim-project",
    opts = {
      -- Define your project directories with glob patterns
      projects = {
        "~/dotfiles/",
        "~/notes/",
        "~/workspace/*",
        "~/workspace/gitlab/*",
        "~/workspace/gitlab/gdk/gitlab/",
      },

      -- Choose your picker: "telescope", "fzf-lua", or "snacks"
      picker = {
        type = "telescope", -- LazyVim includes telescope by default
      },

      -- Load most recent session on startup if not in project
      last_session_on_startup = true,

      -- Dashboard mode prevents session autoload (useful with dashboard)
      dashboard_mode = false,

      -- Patterns for project root detection
      detection_methods = { "pattern", "lsp" }, -- optional
      patterns = { ".git" },
    },

    init = function()
      -- Save global variables to session
      vim.opt.sessionoptions:append("globals")
    end,

    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
      { "Shatur/neovim-session-manager" },
    },

    lazy = false,
    priority = 100,

    keys = {
      { "<leader>fp", "<cmd>Telescope neovim-project discover<cr>", desc = "Find Project" },
      { "<leader>fh", "<cmd>Telescope neovim-project history<cr>", desc = "Project History" },
    },
  },
}
