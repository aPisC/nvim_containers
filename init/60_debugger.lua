local dap = require("dap")
local dapui = require("dapui")


-- Dap UI setup
dapui.setup({
  layouts = {
    {
      elements = {
        {id = "breakpoints", size = 10},
        {id = "scopes", size = 0.66},
        -- "stacks",
        -- "watches",
      },
      size = 30,
      position = "left",
    },
    {
      elements = {
        "repl",
        -- "console",
      },
      size = 10,
      position = "bottom",
    },
  },
})


-- dap.listeners.after.event_initialized["dapui_config"] = function()
--   vim.cmd(":NvimTreeClose")
--   dapui.open()
-- end



-- vim.highlight.create('DapBreakpoint', { ctermbg=0, guifg='#993939', guibg='#31353f' }, false)
-- vim.highlight.create('DapLogPoint', { ctermbg=0, guifg='#61afef', guibg='#31353f' }, false)
-- vim.highlight.create('DapStopped', { ctermbg=0, guifg='#98c379', guibg='#31353f' }, false)

-- vim.fn.sign_define('DapBreakpoint', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
-- vim.fn.sign_define('DapBreakpointCondition', { text='ﳁ', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
-- vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl= 'DapBreakpoint' })
-- vim.fn.sign_define('DapLogPoint', { text='', texthl='DapLogPoint', linehl='DapLogPoint', numhl= 'DapLogPoint' })
vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', linehl='DapStopped', numhl= 'DapStopped' })

