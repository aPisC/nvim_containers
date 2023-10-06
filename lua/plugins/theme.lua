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
  CursorLine = { bg = '#333333' },
}

return {
  {
    'folke/tokyonight.nvim',
    branch = 'main',
    lazy = true
  },

  {
    'Everblush/nvim',
    lazy = true
  },
  {
    'Mofiqul/vscode.nvim',
    lazy = false,
    opts = {
      style = "dark",
      transparent = false,
      italic_comments = true,
      disable_nvimtree_bg = true,
      group_overrides = custom_overrides,
    },
    config = function(plug, opts)
      local vscode = require('vscode')
      vscode.setup(opts)
      vscode.load()
    end
  },
  {
    'navarasu/onedark.nvim',
    -- lazy = true,
    opts = {
      style = 'darker',
      highlights = custom_overrides,
    },
    config = function(plug, opts)
      require('onedark').setup(opts)
      require('onedark').load()
    end
  },
}
