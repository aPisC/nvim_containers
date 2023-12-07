return {
  {'yaocccc/vim-showmarks'},
  {
    'rcarriga/nvim-notify',
    opts = {
      background_colour = "#000000",
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end
  },
  {
    "RRethy/vim-illuminate",
    enabled=false,
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
    'nvim-lualine/lualine.nvim',
    -- enabled = false,
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
        tailwind = "󱏿 ",
        lua = " ",
      }

      local function lsp_client()
        local has_dap, dap = pcall(require, dap)
        local buf_clients = vim.lsp.buf_get_clients()

        local buf_client_names = {}

        if has_dap and dap.session() ~= nil then
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

      local has_git_blame,  git_blame = pcall(require, 'gitblame')

      local config = {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            "neo-tree",
            "edgy",
            "neotest-summary", 
            "qf",
            "Trouble",
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
              has_git_blame and git_blame.get_current_blame_text or function() end,
              cond = function()
                return has_git_blame and vim.g.gitblame_enabled == 1 and git_blame.is_blame_text_available()
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
}
