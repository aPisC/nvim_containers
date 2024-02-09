local custom_overrides = {
  DiagnosticUnderlineError = { bg="#661111", sp="NONE"   },
  DiagnosticUnderlineWarn = { bg="#333300", sp="NONE"   },
  DiagnosticUnderlineInfo = { sp="NONE"   },
  DapBreakpoint  = { fg='#993939'    },
  DapRejected    = { fg='grey'       },
  DapLogPoint    = { fg='#22547a'    },
  DapStopped     = { bg='#555500'    },
  CoqtailChecked = { bg='DarkGreen'  },
  CoqtailSent    = { bg='DarkGreen'  },
  coqProofAdmit  = { fg='DarkOrange' },
  CmpGhostText   = { fg='#888888'    },
  CopilotAnnotation = { fg='#888888', link = "CmpGhostText" },
  CopilotSuggestion = { fg='#888888', link = "CmpGhostText" },
  -- CursorLine = { bg = '#333333' },
  VertSplit = { bg = '#282c34', fg='#000000' },
  NeoTreeVertSplit = { bg = '#282c34', fg='#000000' },
  NeoTreeWinSeparator = { bg = '#282c34', fg='#000000' },
  OverseerTaskBorder = { bg = 'transparent', fg='#888888' },
  FlashLabel = { bg = '#003300', fg = '#8ebd6b' },
  FlashMatch = { bg = '#112244', fg = 'cyan' },
  FlashCursor = { fg = '#112244', bg = 'cyan' },
  -- FlashBackdrop = { fg = '#a0a8b7' },
}

return {
  -- {
  --   'folke/tokyonight.nvim',
  --   branch = 'main',
  --   lazy = true
  -- },

  -- {
  --   'Everblush/nvim',
  --   lazy = true
  -- },
  -- {
  --   'Mofiqul/vscode.nvim',
  --   lazy = false,
  --   opts = {
  --     style = "dark",
  --     transparent = false,
  --     italic_comments = true,
  --     disable_nvimtree_bg = true,
  --     group_overrides = custom_overrides,
  --   },
  --   config = function(plug, opts)
  --     local vscode = require('vscode')
  --     vscode.setup(opts)
  --     vscode.load()
  --   end
  -- },
  {
    'navarasu/onedark.nvim',
    dependencies = {
      "levouh/tint.nvim"
    },
    -- lazy = true,
    opts = {
      transparent = true,
      style = 'darker',
      highlights = custom_overrides,
    },
    config = function(plug, opts)
      require('onedark').setup(opts)
      require('onedark').load()
    end
  },
  {
    "levouh/tint.nvim",
    enabled = true,
    opts = {
      tint = -40,
      tint_background_colors = false,
      -- highlight_ignore_patterns = { "WinSeparator", "Status.*"},
      window_ignore_function = function(winid)
        local bufid = vim.api.nvim_win_get_buf(winid)
        local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
        local floating = vim.api.nvim_win_get_config(winid).relative ~= ""
        local filetyle = vim.api.nvim_buf_get_option(bufid, "filetype")

        -- Do not tint `terminal` or floating windows, tint everything else
        -- vim.notify("filetype: " .. filetype)

        return false -- buftype == "terminal" or buftype == "nofile" or floating or filetype == "neo-tree"
      end
    }
  },
}
