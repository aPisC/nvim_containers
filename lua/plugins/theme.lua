return {
  {
    'folke/tokyonight.nvim',  
    branch = 'main',
    lazy = true
  },
  {
    'navarasu/onedark.nvim', 
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
      group_overrides = {
        DapBreakpoint  = { fg='#993939'    },
        DapRejected    = { fg='grey'       },
        DapLogPoint    = { fg='#22547a'    },
        DapStopped     = { bg='#555500'    },
        CoqtailChecked = { bg='DarkGreen'  },
        CoqtailSent    = { bg='DarkGreen'  },
        coqProofAdmit  = { fg='DarkOrange' },
        CopilotAnnotation = { fg = '#888888'},
        CopilotSuggestion = { fg = '#888888'},
      },
    },
    config = function(plug, opts)
      local vscode = require('vscode')
      vscode.setup(opts)
      vscode.load()
    end
  },
}
