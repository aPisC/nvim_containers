return {
  {
    's1n7ax/nvim-window-picker',
    version = '2.*',
    opts = {
      hint = 'floating-big-letter',
      picker_config = {
        floating_big_letter = {
          font = 'ansi-shadow',
        },
      },
      filter_rules = {
        include_current_win = true,
        autoselect_one = true,
        -- filter using buffer options
        bo = {
          filetype = { 
            'neo-tree', 
            "neo-tree-popup",
            "notify", 
            "Trouble", 
            "dbui", 
            "dbout", 
            "qf", 
            "neotest-summary",
            "edgy",
            "dap-repl",
            "dapui_scopes",
            "dapui_breakpoints",
            "dapui_stacks",
            "dapui_watches",
          },
          buftype = { 'terminal', "quickfix" },
        },
        wo = {
          winhighlight = { "Normal:ShadeOverlay", "Normal:ShadeBrightnessPopup" },
        },
      },
    }
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
        sources = {
          "filesystem",
          "buffers",
          "git_status",
          -- "document_symbols",
        },
        open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
        default_component_configs = {
          git_status = {
            symbols = {
              added     = "",
              modified  = "",
              deleted   = "✖",
              renamed   = "󰁕",
              untracked = "✚",
              ignored   = "",
              unstaged  = "",
              staged    = "󰄴",
              conflict  = "",
            }
          },
        },
        window = {
          mappings = {
            ["<cr>"] = "open_with_window_picker",
            ["S"] = "split_with_window_picker",
            ["s"] = "vsplit_with_window_picker",
            ["<F2>"] = "rename",
          }
        },
        source_selector = {
          winbar = true,
          sources = {
            { source = "filesystem" },
            { source = "buffers" },
            { source = "git_status" },
            -- { source = "document_symbols" },
          },
        },
        filesystem = {
          scan_mode = "deep",
          follow_current_file = {
            enabled = true, -- This will find and focus the file in the active buffer every time
            --               -- the current file is changed while the tree is open.
            leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
          },
          group_empty_dirs = true,
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = true,
            always_show = {
              ".vscode",
            },
            hide_by_pattern =  {
              ".bsp",
              ".git",
            }
          },
          window = {
            mappings = {
              ["gs"] = "git_add_file",
              ["ga"] = "git_add_file",
              ["gu"] = "git_unstage_file",
              ["gp"] = "git_push",
              ["Z"] = "expand_all_nodes",
            }
          }
        },
        git_status = {
          window = {
            mappings = {
              ["s"] = "git_add_file",
              ["u"] = "git_unstage_file",
              ["c"] = "git_commit",
              ["p"] = "git_push",
            }
          }
        }

    }
  },
}
