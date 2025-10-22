-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
    },
  },

  -- == Examples of Overriding Plugins ==
  --
  {
    "nvim-telescope/telescope-project.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
  },

  -- {
  --   "coffebar/neovim-project",
  --   opts = {
  --     projects = { -- define project roots
  --       "~/workspace/*",
  --       "~/workspace/ai/*",
  --       "~/workspace/gitlab/*",
  --       "~/workspace/gitlab/dedicated/*",
  --       "~/workspace/gitlab/k8s-workloads/*",
  --       "~/.config/nvim/",
  --     },
  --   },
  --   init = function()
  --     -- enable saving the state of plugins in the session
  --     vim.opt.sessionoptions:append "globals" -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
  --   end,
  --   dependencies = {
  --     { "nvim-lua/plenary.nvim" },
  --     { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
  --     { "Shatur/neovim-session-manager" },
  --   },
  --   lazy = false,
  --   priority = 100,
  -- },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "jonarrien/telescope-cmdline.nvim",
    },
    keys = {
      { "<leader><leader>", "<cmd>Telescope cmdline<cr>", desc = "Cmdline" },
    },
    opts = {
      extensions = {
        project = {
          base_dirs = {
            "~/workspace/gitlab",
            "~/dotfiles/",
          },
          sync_with_nvim_tree = true,
          hidden_files = true,
          on_project_selected = function(prompt_bufnr)
            local project_actions = require "telescope._extensions.project.actions"
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
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension "cmdline"
      require("telescope").load_extension "fzf"
    end,
  },
  {
    "princejoogie/dir-telescope.nvim",
    -- telescope.nvim is a required dependency
    requires = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("dir-telescope").setup {
        -- these are the default options set
        hidden = true,
        no_ignore = false,
        show_preview = true,
        follow_symlinks = false,
      }
    end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this to "*" if you want to always pull the latest change, false to update on release
    opts = {
      provider = "litellm_gemini_pro",
      cursor_applying_provider = "litellm_gemini_pro",
      auto_suggestions_provider = "litellm_gemini_pro",
      -- rag_service = {
      --   enabled = true, -- Enables the RAG service
      --   host_mount = "/Users/vglafirov/workspace/ai/trading-platform/",
      --   provider = "openai", -- The provider to use for RAG service (e.g. openai or ollama)
      --   endpoint = "https://llm.vglafirov.com/v1/",
      -- },
      providers = {
        gitlab = {
          chat_model = "claude-3-5-sonnet-20241022",
          code_suggestion_model = "claude-3-5-sonnet-20241022",
        },
        groq = { -- define groq provider
          __inherited_from = "openai",
          api_key_name = "GROQ_API_KEY",
          endpoint = "https://api.groq.com/openai/v1/",
          model = "llama-3.3-70b-versatile",
          extra_request_body = {
            max_tokens = 32768, -- remember to increase this value, otherwise it will stop generating halfway
          },
        },
        litellm_gemini_pro = {
          __inherited_from = "openai",
          endpoint = "https://llm.vglafirov.com/v1/",
          api_key_name = "LITELLM_API_KEY",
          model = "gemini/gemini-2.5-pro",
          extra_request_body = {
            max_tokens = 1048573, -- remember to increase this value, otherwise it will stop generating halfway
            max_completion_tokens = 65536,
          },
        },
        litellm_openai_gpt5 = {
          __inherited_from = "openai",
          endpoint = "https://llm.vglafirov.com/v1/",
          api_key_name = "LITELLM_API_KEY",
          model = "gpt-5",
        },
        litellm_openai_gpt5_codex = {
          __inherited_from = "openai",
          endpoint = "https://llm.vglafirov.com/v1/",
          api_key_name = "LITELLM_API_KEY",
          model = "gpt-5-codex",
        },
        ollama = {
          api_key_name = "",
          endpoint = "http://192.168.1.55:11434",
          model = "qwen3:latest",
          -- disable_tools = true, -- Open-source models often do not support tools.
        },
        gemini = {
          model = "gemini-2.5-pro", -- your desired model (or use gpt-4o, etc.)
          timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
          extra_request_body = {
            temperature = 0,
            max_tokens = 1048573, -- Increase this to include reasoning tokens (for reasoning models)
          },
        },
        claude = {
          api_key_name = "LITELLM_API_KEY",
          endpoint = "https://llm.vglafirov.com",
          timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
          model = "claude-sonnet-4-5",
          extra_request_body = {
            max_tokens = 64000,
          },
        },
      },
      web_search_engine = {
        provider = "searxng",
      },
      behaviour = {
        enable_claude_text_editor_tool_mode = true,
        enable_cursor_planning_mode = true,
        auto_suggestions = false, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = true,
        support_paste_from_clipboard = true,
        minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
        enable_token_counting = true, -- Whether to enable token counting. Default to true.
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },

  -- disable Gitlab LSP due to https://gitlab.com/gitlab-org/editor-extensions/gitlab.vim/-/issues/108
  -- {
  --   "git@gitlab.com:gitlab-org/editor-extensions/gitlab.vim.git",
  --   commit = "cf304d18ba352e7bf914af978f4c1aab7ffb7e49",
  --   lazy = false,
  --   -- Activate when a file is created/opened
  --   event = { "BufReadPre", "BufNewFile" },
  --   -- Activate when a supported filetype is open
  --   ft = { "go", "javascript", "python", "ruby" },
  --   cond = function()
  --     -- Only activate if token is present in environment variable.
  --     -- Remove this line to use the interactive workflow.
  --     return vim.env.GITLAB_TOKEN ~= nil and vim.env.GITLAB_TOKEN ~= ""
  --   end,
  --   opts = {
  --     statusline = {
  --       -- Hook into the built-in statusline to indicate the status
  --       -- of the GitLab Duo Code Suggestions integration
  --       enabled = false,
  --     },
  --   },
  -- },
  -- {
  --   "rest-nvim/rest.nvim",
  -- },
  -- {
  --   "Al0den/notion.nvim",
  --   lazy = false, --Should work when lazy loaded, not tested
  --   dependencies = {
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-lua/plenary.nvim",
  --   },
  --   config = function() require("notion").setup() end,
  -- },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim", -- optional
      "ibhagwan/fzf-lua", -- optional
    },
    config = true,
  },
  -- {
  --   "nyngwang/NeoZoom.lua",
  --   lazy = false,
  --   config = function()
  --     require("neo-zoom").setup {
  --       popup = { enabled = true }, -- this is the default.
  --       -- NOTE: Add popup-effect (replace the window on-zoom with a `[No Name]`).
  --       -- EXPLAIN: This improves the performance, and you won't see two
  --       --          identical buffers got updated at the same time.
  --       -- popup = {
  --       --   enabled = true,
  --       --   exclude_filetypes = {},
  --       --   exclude_buftypes = {},
  --       -- },
  --       exclude_buftypes = { "mason" },
  --       -- exclude_filetypes = { 'lspinfo', 'mason', 'lazy', 'fzf', 'qf' },
  --       winopts = {
  --         offset = {
  --           -- NOTE: omit `top`/`left` to center the floating window vertically/horizontally.
  --           -- top = 0,
  --           -- left = 0.17,
  --           width = 500,
  --           height = 1,
  --         },
  --         -- NOTE: check :help nvim_open_win() for possible border values.
  --         border = "thicc", -- this is a preset, try it :)
  --       },
  --       presets = {
  --         {
  --           -- NOTE: regex pattern can be used here!
  --           filetypes = { "dapui_.*", "dap-repl" },
  --           winopts = {
  --             offset = { top = 0.02, left = 0.26, width = 0.74, height = 0.25 },
  --           },
  --         },
  --         {
  --           filetypes = { "markdown" },
  --           callbacks = {
  --             function() vim.wo.wrap = true end,
  --           },
  --         },
  --       },
  --     }
  --     vim.keymap.set("n", "<CR>", function() vim.cmd "NeoZoomToggle" end, { silent = true, nowait = true })
  --   end,
  -- },
  {
    "AckslD/nvim-neoclip.lua",
    requires = {
      { "nvim-telescope/telescope.nvim" },
      { "ibhagwan/fzf-lua" },
    },
    config = function() require("neoclip").setup() end,
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<m-h>", "<cmd> TmuxNavigateLeft<cr>" },
      { "<m-j>", "<cmd> TmuxNavigateDown<cr>" },
      { "<m-k>", "<cmd> TmuxNavigateUp<cr>" },
      { "<m-l>", "<cmd> TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd> TmuxNavigatePrevious<cr>" },
    },
  },
  -- customize alpha options
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      opts.section.header.val = {
        " █████  ███████ ████████ ██████   ██████",
        "██   ██ ██         ██    ██   ██ ██    ██",
        "███████ ███████    ██    ██████  ██    ██",
        "██   ██      ██    ██    ██   ██ ██    ██",
        "██   ██ ███████    ██    ██   ██  ██████",
        " ",
        "    ███    ██ ██    ██ ██ ███    ███",
        "    ████   ██ ██    ██ ██ ████  ████",
        "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
        "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
        "    ██   ████   ████   ██ ██      ██",
      }
      return opts
    end,
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
}
