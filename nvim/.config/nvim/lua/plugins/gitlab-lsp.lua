return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gitlab_lsp = {
          cmd = { "gitlab-lsp", "--stdio" },
          settings = {
            gitlab = {
              baseUrl = "https://gitlab.com", -- or your GitLab instance URL
              token = vim.env.GITLAB_TOKEN,
            },
          },
        },
      },
    },
  },
}
