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
