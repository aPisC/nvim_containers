local dap = require("dap")
local dapui = require("dapui")


-- Dap UI setup
dapui.setup({
  layouts = {
    {
      elements = {
        {id = "breakpoints", size = 10},
        {id = "watches", size = 0.33},
        {id = "scopes", size = 0.33},
        -- "stacks",
      },
      size = 30,
      position = "left",
    },
    -- {
    --   elements = {
    --     "repl",
    --     -- "console",
    --   },
    --   size = 10,
    --   position = "bottom",
    -- },
  },
  icons = {
    collapsed = "",
    current_frame = "",
    expanded = ""
  },
  controls = {
    element = "scopes",
  },
  expand_lines = false,
})



-- dap.listeners.after.event_initialized["dapui_config"] = function()
--   vim.cmd(":NvimTreeClose")
--   dapui.open()
-- end

vim.fn.sign_define('DapBreakpoint', { text='', texthl='DapBreakpoint', linehl='', numhl='' })
vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapRejected', linehl='', numhl= '' })
vim.fn.sign_define('DapBreakpointCondition', { text='', texthl='DapBreakpoint', linehl='', numhl='' })
vim.fn.sign_define('DapLogPoint', { text='', texthl='DapLogPoint', linehl='', numhl= '' })
vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', linehl='DapStopped', numhl= 'DapStopped' })


vim.diagnostic.config({underline=false, severity_sort=true})
vim.fn.sign_define('DiagnosticSignError', { text='', texthl='DiagnosticSignError', linehl='', numhl= '' })
vim.fn.sign_define('DiagnosticSignWarn', { text='', texthl='DiagnosticSignWarn', linehl='', numhl= '' })
vim.fn.sign_define('DiagnosticSignInfo', { text='󰙎', texthl='DiagnosticSignInfo', linehl='', numhl= '' })
vim.fn.sign_define('DiagnosticSignHint', { text='󰙎', texthl='DiagnosticSignHint', linehl='', numhl= '' })

