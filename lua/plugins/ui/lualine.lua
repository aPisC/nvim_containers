local function lsp_progress(_, is_active)
  -- if not is_active then
  --   return
  -- end
  -- local messages = vim.lsp.util.get_progress_messages()
  local messages = (vim.lsp.status or vim.lsp.util.get_progress_messages)()
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


return {
  {
      "smiteshp/nvim-navic",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      lsp = {
        auto_attach = true,
        preference = nil,
      },
      highlight = true,
    }
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      "smiteshp/nvim-navic",
    },
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


      local function VMInfoSegment()
        local success, infos = pcall(vim.call, "VMInfos")
        if not success then return "" end
        if not infos.status then return "" end
        return "MC " .. infos.ratio 
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
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {
            { VMInfoSegment, color = {bg = "#e55561"}, separator = { right = ""}, cond = function() return  VMInfoSegment() ~= "" end},
            {'mode', cond = function() return  VMInfoSegment() == "" end}, 
          },
          lualine_b = {
            'branch',
            'diff',
            { 'diagnostics', on_click=function() vim.diagnostic.setqflist() end }
          },
          lualine_c = {
            -- 'filename',
            {
              has_git_blame and git_blame.get_current_blame_text or function() end,
              cond = function()
                return has_git_blame and git_blame.is_blame_text_available()
              end
            },
          },
          lualine_x = {
            { "lsp_progress" },
            'encoding',
            'fileformat',
            'filetype',
            { "lsp_clients"},
            { "toggleterm_icons"  }
          },
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 
            { 'filename', path=1} 
          },
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {
          lualine_a = { "project_name" },
          lualine_b = { "buffers" },
          lualine_c = {},
          lualine_x = {},
          -- lualine_x = {{ function() return '%0@v:lua.print@Clicky stuff%T' end }},
          lualine_y = { "tabs", },
          lualine_z = {}
        },
        winbar = {
          lualine_a = { },
          lualine_b = { 
            {
              "filename", 
              cond = function() return not vim.api.nvim_buf_get_name(0):match("^oil://") end,
              path = 1,
            },
            {
              function() return require('oil').get_current_dir() end,
              cond = function() return vim.api.nvim_buf_get_name(0):match("^oil://") and true end
            },
          },
          lualine_c = { "navic" },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
        inactive_winbar = {
          lualine_a = {},
          lualine_b = {
            {
              "filename", 
              cond = function() return not vim.api.nvim_buf_get_name(0):match("^oil://") end,
              path = 1,
            },
            {
              function() return require('oil').get_current_dir() end,
              cond = function() return vim.api.nvim_buf_get_name(0):match("^oil://") and true end
            },
          },
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}

        },
        extensions = {}
      }

      return config
    end
  },
}
