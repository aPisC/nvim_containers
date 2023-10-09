return {
  {'yaocccc/vim-showmarks'},
  {
    'rcarriga/nvim-notify',
    opts = {},
    config = function()
      vim.notify = require("notify")
    end
  },
  {
    "RRethy/vim-illuminate",
    opts = { },
    config = function(plug, opts)
      require('illuminate').configure(opts)
    end
  },
  {
    'anuvyklack/pretty-fold.nvim',
     opts = {},
  },
  {
    'norcalli/nvim-colorizer.lua',
    opts = {"*"},
    init=function()
      vim.opt.termguicolors = true
    end
  },
  {
    'utilyre/barbecue.nvim',
    dependencies = {
      "smiteshp/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {}
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
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
              filetype = { 'neo-tree', "neo-tree-popup", "notify" },
              buftype = { 'terminal', "quickfix" },
            },
            wo = {
               winhighlight = { "Normal:ShadeOverlay", "Normal:ShadeBrightnessPopup" },
            },
          },
        }
      },
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
  {
    'nvim-lualine/lualine.nvim',
    opts = function()
      local colors = {
        yellow = '#ECBE7B',
        cyan = '#008080',
        darkblue = '#081633',
        green = '#98be65',
        orange = '#FF8800',
        violet = '#a9a1e1',
        magenta = '#c678dd',
        blue = '#51afef',
        red = '#ec5f67'
      }

      local lsp_icons = {
        copilot = " ",
        tsserver = " ",
        ["typescript-tools"] = " ",
        emmet_ls = " ",
        metals = " ",
        omnisharp = "󰌛 ",
      }

      local function lsp_client()
        local buf_clients = vim.lsp.buf_get_clients()

        local buf_client_names = {}

        if (require"dap".session() ~= nil) then
          table.insert(buf_client_names, " ")
        end


        for _, client in pairs(buf_clients) do
          if lsp_icons[client.name] ~= nil then
            table.insert(buf_client_names, lsp_icons[client.name])
          elseif lsp_icons[client.name] ~= false then
            table.insert(buf_client_names, "[" .. client.name .. "]")
          end
        end

        if #buf_client_names == 0 then return "" end
        return table.concat(buf_client_names, " ")
      end

      local function lsp_progress(_, is_active)
        if not is_active then
          return
        end
        local messages = vim.lsp.util.get_progress_messages()
        if #messages == 0 then
          return ""
        end
        local status = {}
        for _, msg in pairs(messages) do
          if msg.name ~= "null-ls" then
            local title = ""
            if msg.title then
              title = msg.title
            end
            table.insert(status, (msg.percentage or 0) .. "%% " .. title)
          end
        end
        if #status == 0 then return "" end

        local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        local ms = vim.loop.hrtime() / 1000000
        local frame = math.floor(ms / 120) % #spinners
        return table.concat(status, "  ") .. " " .. spinners[frame + 1]
      end

      local git_blame = require('gitblame')

      local config = {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            "neo-tree",
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {
            'branch',
            -- 'diff',
            'diagnostics'
          },
          lualine_c = {
            -- 'filename',
            {
              git_blame.get_current_blame_text,
              cond = function()
                return vim.g.gitblame_enabled == 1 and git_blame.is_blame_text_available()
              end
            },
            { lsp_progress },
          },
          lualine_x = {
            'encoding',
            'fileformat',
            'filetype',
            { lsp_client },
          },
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}

      }

      return config
    end
  },
  {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    enabled = false,
    opts = {
      options={
        -- mode="tabs",
        -- separator_style="slant",
        diagnostics = "nvim_lsp",
        left_mouse_command = function (bufnr)
          local winid = vim.fn.win_findbuf(bufnr)[1]
          if winid ~= nil then
            vim.fn.win_gotoid(winid)
            return
          end
          vim.cmd("buf " .. bufnr)
        end,
        offsets = {
          {
              filetype = "dapui_breakpoints",
              text = "Debugger",
              highlight = "Directory",
              separator = true -- use a "true" to enable the default, or set your own character
          },
          {
              filetype = "dapui_scopes",
              text = "Debugger",
              highlight = "Directory",
              separator = true -- use a "true" to enable the default, or set your own character
          },
          {
              filetype = "neo-tree",
              text = "File Explorer",
              highlight = "Directory",
              separator = true -- use a "true" to enable the default, or set your own character
          },
        }
      }
    }
  },
  {
    'luukvbaal/statuscol.nvim',
    init = function()
      vim.fn.sign_define('DapBreakpoint', { text='', texthl='DapBreakpoint', linehl='', numhl='' })
      vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapRejected', linehl='', numhl= '' })
      vim.fn.sign_define('DapBreakpointCondition', { text='', texthl='DapBreakpoint', linehl='', numhl='' })
      vim.fn.sign_define('DapLogPoint', { text='', texthl='DapLogPoint', linehl='', numhl= '' })
      vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', linehl='DapStopped', numhl= 'DapStopped' })


      vim.fn.sign_define('DiagnosticSignError', { text='', texthl='DiagnosticSignError', linehl='', numhl= '' })
      vim.fn.sign_define('DiagnosticSignWarn', { text='', texthl='DiagnosticSignWarn', linehl='', numhl= '' })
      vim.fn.sign_define('DiagnosticSignInfo', { text='󰙎', texthl='DiagnosticSignInfo', linehl='', numhl= '' })
      vim.fn.sign_define('DiagnosticSignHint', { text='󰙎', texthl='DiagnosticSignHint', linehl='', numhl= '' })
    end,
    opts = function()
      local builtin = require("statuscol.builtin")
      return {
        setopt = true,
        thousands = false,
        relculright = true,
        ft_ignore = { "neo-tree" },
        bt_ignore = nil,
        segments = {
          {
            sign = { name = { "GitSigns" }, maxwidth = 1, colwidth=1, auto = false, wrap=true },
            click = "v:lua.ScSa"
          },
          {
            sign = { name = { "Diagnostic" }, fillchar=" ", maxwidth = 1, colwidth=1, auto = false, wrap=false },
            click = "v:lua.ScSa"
          },
          -- {
          --   sign = { name = { "LightBulb" }, fillchar=" ", maxwidth = 1, auto = false, wrap=false },
          --   click = "v:lua.ScSa"
          -- },
          {
            sign = { name = { ".*" }, maxwidth = 1, colwidth = 1, auto = false, wrap = false },
            click = "v:lua.ScSa"
          },
          {
            text = { builtin.lnumfunc, "" },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
          {
            sign = { name = { "Dap" }, fillchar=" ", maxwidth = 1, auto = true },
            click = "v:lua.ScSa"
          },
          {
            text = { '%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? "" : "") : " " }', " " },       -- table of strings or functions returning a string
            click = "v:lua.ScFa",  -- %@ click function label, applies to each text element
            -- hl = "FoldColumn",     -- %# highlight group label, applies to each text element
            condition = { true },  -- table of booleans or functions returning a boolean
            sign = {               -- table of fields that configure a sign segment
              maxwidth = 1,        -- maximum number of signs that will be displayed in this segment
              colwidth = 2,        -- number of display cells per sign in this segment
              auto = false,        -- when true, the segment will not be drawn if no signs matching the pattern are currently placed in the buffer.
              wrap = false,        -- when true, signs in this segment will also be drawn on the virtual or wrapped part of a line (when v:virtnum != 0).
              fillchar = " ",      -- character used to fill a segment with less signs than maxwidth
              fillcharhl = nil,    -- highlight group used for fillchar (SignColumn/CursorLineSign if omitted)
            }
          },
        },
        clickmod = "c",
        clickhandlers = {
          Lnum                    = builtin.lnum_click,
          FoldClose               = builtin.foldclose_click,
          FoldOpen                = builtin.foldopen_click,
          FoldOther               = builtin.foldother_click,
          DapBreakpointRejected   = builtin.toggle_breakpoint,
          DapBreakpoint           = builtin.toggle_breakpoint,
          DapBreakpointCondition  = builtin.toggle_breakpoint,
          DiagnosticSignError     = builtin.diagnostic_click,
          DiagnosticSignHint      = builtin.diagnostic_click,
          DiagnosticSignInfo      = builtin.diagnostic_click,
          DiagnosticSignWarn      = builtin.diagnostic_click,
          GitSignsTopdelete       = builtin.gitsigns_click,
          GitSignsUntracked       = builtin.gitsigns_click,
          GitSignsAdd             = builtin.gitsigns_click,
          GitSignsChange          = builtin.gitsigns_click,
          GitSignsChangedelete    = builtin.gitsigns_click,
          GitSignsDelete          = builtin.gitsigns_click,
          gitsigns_extmark_signs_ = builtin.gitsigns_click,
          LightBulbSign           = function(args) vim.lsp.buf.code_action() end,
        },
      }
    end,
  },
}
