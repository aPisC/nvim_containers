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


dap.listeners.after.event_initialized["dapui_config"] = function()
  vim.cmd(":NvimTreeClose")
  dapui.open()
end




