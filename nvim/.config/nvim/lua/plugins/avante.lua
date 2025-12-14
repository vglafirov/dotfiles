return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this to "*" if you want to always pull the latest change, false to update on release
    opts = {
      debug = false,
      acp_providers = {
        ["opencode"] = {
          command = "opencode",
          args = { "acp" },
          env = {
            GITLAB_TOKEN = os.getenv("GITLAB_TOKEN"),
          },
        },
      },
      provider = "opencode",
      -- provider = "gitlab_duo",
      -- provider = "claude",
      -- provider = "litellm_gemini_pro",
      -- provider = "gemini",
      -- cursor_applying_provider = "gitlab_duo",
      -- auto_suggestions_provider = "gitlab_duo",
      -- rag_service = {
      --   enabled = true, -- Enables the RAG service
      --   host_mount = "/Users/vglafirov/workspace/ai/trading-platform/",
      --   provider = "openai", -- The provider to use for RAG service (e.g. openai or ollama)
      --   endpoint = "https://llm.vglafirov.com/v1/",
      -- },
      providers = {
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
          model = "gemini/gemini-3-pro-preview",
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
        litellm_claude_haiku_4_5 = {
          __inherited_from = "claude",
          endpoint = "https://llm.vglafirov.com/v1/",
          api_key_name = "LITELLM_API_KEY",
          model = "claude-haiku-4-5",
        },
        litellm_claude_sonnet_4_5 = {
          __inherited_from = "claude",
          endpoint = "https://llm.vglafirov.com/v1/",
          api_key_name = "LITELLM_API_KEY",
          model = "claude-sonnet-4-5",
        },
        ollama = {
          api_key_name = "",
          endpoint = "http://192.168.1.55:11434",
          model = "qwen3:latest",
          -- disable_tools = true, -- Open-source models often do not support tools.
        },
        gemini = {
          model = "gemini-3-pro-preview", -- your desired model (or use gpt-4o, etc.)
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
  },
}
