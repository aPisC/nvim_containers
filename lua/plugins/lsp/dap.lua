return {
  {
    -- DAP
    'mfussenegger/nvim-dap',
    event = "VeryLazy",
    dependencies = {
      {
        -- DAP UI
        'rcarriga/nvim-dap-ui',
        dependencies = { {'mfussenegger/nvim-dap' }, { 'nvim-neotest/nvim-nio' } },
        opts = {
          layouts = {
            {
              elements = {
                {id = "breakpoints", size = 10},
                {id = "watches", size = 0.33},
                {id = "scopes", size = 0.33},
              },
              size = 30,
              position = "left",
            },
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
        }
      },
    },
    keys = {
      {'<F5>', function() require("dap").continue() end, mode={'n', 'i'}},
      {'<F6>', function() require("dap").run_last() end, mode={'n', 'i'}},
      {'<F17>', function() require("dap").terminate() end, mode={'n', 'i'}},
      {'<F9>', function() require("dap").toggle_breakpoint() end, mode={'n', 'i'}},
      {
        '<F21>',
        function()
          local condition = vim.fn.input("Condition: ")
          if condition ~= "" then
            require("dap").set_breakpoint(condition)
            return
          end

          local logMessage = vim.fn.input("Log message: ")
          if logMessage ~= "" then
            require("dap").set_breakpoint(nil, nil, logMessage)
            return
          end

          require("dap").set_breakpoint()
        end,
        mode={'n', 'i'}
      },
      {'<F10>', function() require("dap").step_over() end, mode={'n', 'i'}},
      {'<F11>', function() require("dap").step_into() end, mode={'n', 'i'}},
      {'<F23>', function() require("dap").step_out() end, mode={'n', 'i'}},
      {'<C-g>r', function() require("dap").repl.toggle({height=10}) end}
    },
    commands = {
      {'DapRun', function() require('dap').run() end},
      {'DapRunLast', function() require('dap').run_last() end},
      {'DapRepl', function() require('dap').repl.toggle({height=10}) end},
      {'DapUi', function() require("dapui").toggle() end},
      {'DapStacks', function() require('dapui').float_element("stacks", {enter=true}) end},
      {'DapWatch', function() require('dapui').float_element("watches", {enter=true}) end},
      {'DapLocals', function() require('dapui').float_element("scopes", {enter=true}) end},
      {'DapBreakpoints', function() require('dapui').float_element("breakpoints", {enter=true}) end},
      {'DapEval', function() require('dapui').eval() end},
    },
    config = function(plug)
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      for _, c in ipairs(plug.commands) do
        vim.api.nvim_create_user_command(c[1], c[2], c[3] or { nargs = 0, force = true })
      end
    end
  },
}
