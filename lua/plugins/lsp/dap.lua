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
      {'DapUi', function() require("dapui").toggle() end},
      {'DapRun', function() require('dap').run() end},
      {'DapRunLast', function() require('dap').run_last() end},
      {'DapRepl', function() require('dap').repl.toggle({height=10}) end},
    },
    config = function()
      local dap = require("dap")
      -- configure dap events
      dap.listeners.before['event_stopped']['dapui_event_handling'] = function(session, body)
        vim.cmd(":Neotree action=close")
        require("dapui").open()
      end
      dap.listeners.after['event_terminated']['dap-ui'] = function(session, body)
        if not body.restart then
          require("dapui").close()
        end
      end
      dap.listeners.after['terminated']['dap-ui'] = function(session, body)
        if not body.restart then
          require("dapui").close()
        end
      end
    end
  },
}
