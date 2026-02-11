local osu = require("utils.os")

return {
  {
    'saghen/blink.cmp',
    dependencies = {
      'Kaiser-Yang/blink-cmp-avante',
    },
    opts = {
      enabled = {
        ["DressingInput"] = false,
      },
      completion = {
        ghost_text = {
          enabled = { AvanteInput = false, AvantePromptInput = false },
        },  
        menu = {
          auto_show = { AvanteInput = true, AvantePromptInput = true },
        }
      },
      sources = {
        per_filetype = {
          AvanteInput = { "avante" },
          AvantePromptInput = { "avante" }
        },
        providers = {
          avante = { module = 'blink-cmp-avante', name = 'Avante', opts = { } },
        },
      },
    },
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    enabled = false,
    version = false, -- Never set this value to "*"! Never!
    opts = {
      debug=false,
      provider = osu.cond({ linux = "claude", windows = "copilot" }),
      behaviour = {
        enable_cursor_planning_mode = false,
        enable_claude_text_editor_tool_mode = false,
        use_cwd_as_project_root = true,
      },
      selector = { },
      mappings = {
        submit = {
          insert = "<C-CR>",
        },
        sidebar = {
          -- switch_windows = "<PageDown>",
          -- reverse_switch_windows = "<PageUp>",
        }
      },
      custom_tools = {
        -- require("llm-tools.nvim-file-open")({}),
        -- require("llm-tools.nvim-terminal-open")({}),
        -- require("llm-tools.nvim-terminal-list")({}),
        -- require("llm-tools.nvim-terminal-read")({}),
        -- require("llm-tools.nvim-terminal-input")({}),
      },
      system_prompt =function(arg)
        print(vim.inspect(arg))
        return (
[[
Other things to keep in mind:
- Ignore the system language and use english when you communicate with the user.
- After making changes, ALWAYS make sure to start up a new server so I can test it.
- Always look for existing code to iterate on instead of creating new code.
- Do not drastically change the patterns before trying to iterate on existing patterns.
- Always kill all existing related servers that may have been created in previous testing before trying to start a new server.
- Always prefer simple solutions
- Avoid duplication of code whenever possible, which means checking for other areas of the codebase that might already have similar code and functionality
- Write code that takes into account the different environments: dev, test, and prod
- You are careful to only make changes that are requested or you are confident are well understood and related to the change being requested
- When fixing an issue or bug, do not introduce a new pattern or technology without first exhausting all options for the existing implementation. And if you finally do this, make sure to remove the old implementation afterwards so we don't have duplicate logic.
- Keep the codebase very clean and organized
- Avoid writing scripts in files if possible, especially if the script is likely only to be run once
- Avoid having files over 200-300 lines of code. Refactor at that point.
- Mocking data is only needed for tests, never mock data for dev or prod
- Never add stubbing or fake data patterns to code that affects the dev or prod environments
- Never overwrite my .env file without first asking and confirming
- Focus on the areas of code relevant to the task
- Do not touch code that is unrelated to the task
- Write thorough tests for all major functionality
- Avoid making major changes to the patterns and architecture of how a feature works, after it has shown to work well, unless explicitly instructed
- Always think about what other methods and areas of code might be affected by code changes
- Stick to the desired format, prefer showing your ideas in code change blocks that can be applied
]])
        end
      },
      build = osu.cond({
        linux = "make",
        windows = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false",
      }),
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "ibhagwan/fzf-lua", -- for file_selector provider fzf
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
          -- support for image pasting
          "HakonHarnes/img-clip.nvim",
          event = "VeryLazy",
          opts = {
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
              use_absolute_path = osu.cond({
                linux = false,
                windows = true, 
              }),
            },
          },
        },
        {
          'MeanderingProgrammer/render-markdown.nvim',
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
      },
    },
  }
