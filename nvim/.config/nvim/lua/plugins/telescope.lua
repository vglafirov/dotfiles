return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      extensions = {
        project = {
          base_dirs = {
            "~/workspace/",
            "~/dotfiles/",
          },
          sync_with_nvim_tree = true,
          hidden_files = true,
          on_project_selected = function(prompt_bufnr)
            local project_actions = require("telescope._extensions.project.actions")
            project_actions.change_working_directory(prompt_bufnr, false)
          end,
        },
        fzf = {},
        cmdline = {
          -- Adjust telescope picker size and layout
          picker = {
            theme = "ivy",
          },
        },
      },
    },
  },
}
