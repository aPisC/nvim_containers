return { 
  -- {
  --   'lewis6991/gitsigns.nvim',
  --   opts = {},
  --   enable=false
  --   -- event = "VeryLazy",
  -- },
  {
    'luukvbaal/statuscol.nvim',
    dependencies = {
    },
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

      vim.opt.foldcolumn = "1"
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldlevel = 20
      vim.opt.fcs = vim.opt.fcs._value .. (vim.opt.fcs._value == "" and "" or ",") .. "fold:#,foldopen:,foldclose:"
    end,
    enabled = true,
    opts = function()
      local builtin = require("statuscol.builtin")
      return {
        setopt = true,
        thousands = false,
        relculright = true,
        ft_ignore = { "neo-tree", "NeogitStatus" },
        bt_ignore = { "terminal" },
        segments = {
          { 
            sign = { namespace = {"diagnostic"}, maxwidth = 1, colwidth = 1, auto = true, wrap = false, fillchar=' ' },
            click = "v:lua.ScSa"
          },
          { 
            sign = { name = { ".*" }, namespace = {".*"}, maxwidth = 2, colwidth = 1, auto = true, wrap = false, fillchar=' ' },
            click = "v:lua.ScSa"
          },
          {
            sign = { namespace = {"gitsigns_signs"}, maxwidth = 1, colwidth = 2, auto = true, wrap = true },
            click = "v:lua.ScSa"
          },
          {
            text = { builtin.lnumfunc, "" },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
          {
            sign = { name = { "Dap" }, maxwidth = 1, colwidth = 1, auto = false, wrap = false, fillchar=' ' },
            click = "v:lua.ScLa"
          },
          { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
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
