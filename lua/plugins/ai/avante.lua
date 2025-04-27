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
    enabled = true,
    version = false, -- Never set this value to "*"! Never!
    opts = {
      debug=true,
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
        require("llm-tools.nvim-file-open")({}),
        require("llm-tools.nvim-terminal-open")({}),
      },
      system_prompt = [[
Ignore the system language and use english when you communicate with the user.
      ]]
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
