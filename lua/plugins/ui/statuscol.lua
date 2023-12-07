return {
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
        bt_ignore = { "terminal" },
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
