return {
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = "VeryLazy",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = {highlight_whole_line = false, only_current_line= true},
      })
    end,
  },
  -- { 'echasnovski/mini.animate', version = false, },
  -- {   "karb94/neoscroll.nvim",  },
  -- {
  --   'edluffy/specs.nvim',
  --   opts = function () return {
  --     show_jumps  = true,
  --     min_jump = 30,
  --     popup = {
  --       delay_ms = 0, -- delay before popup displays
  --       inc_ms = 50, -- time increments used for fade/resize effects
  --       blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
  --       width = 10,
  --       winhl = "PMenu",
  --       fader = require('specs').linear_fader,
  --       resizer = require('specs').shrink_resizer
  --     },
  --     ignore_filetypes = {},
  --     ignore_buftypes = {
  --       nofile = true,
  --     },
  --   }
  -- end
  -- }
}
