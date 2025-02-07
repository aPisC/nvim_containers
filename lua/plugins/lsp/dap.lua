return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
      {
        'mrjones2014/legendary.nvim',
        opts = {
          ["dap"] = {
            icon = '',
            itemgroup = "Dap",
            keymaps = {
              {'<F5>', function() require("dap").continue() end, mode={'n', 'i'}, description="Continue debugging"},
              {'<F41>', function() require("dap").run_last() end, mode={'n', 'i'}, description="Run last debugging configuration (󰘳 󰘶 󱊯 )"},
              {'<F17>', function() require("dap").terminate() end, mode={'n', 'i'}, description="Stop debugging (󰘶 󱊯 )"},
              {'<F9>', function() require("dap").toggle_breakpoint() end, mode={'n', 'i'}, description="Toggle breakpoint"},
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
                mode={'n', 'i'},
                description="Toggle conditional breakpoint (󰘶 󱊳 )"
              },
              {'<F10>', function() require("dap").step_over() end, mode={'n', 'i'}, description="Step over"},
              {'<F11>', function() require("dap").step_into() end, mode={'n', 'i'}, description="Step into"},
              {'<F23>', function() require("dap").step_out() end, mode={'n', 'i'}, description="Step out (󰘶 󱊵 )"},
              {'<C-g>r', function() require("dap").repl.toggle({height=10}) end, description="Open Dap Repl"}
            }
          }
        }
      },
    },
    opts = {
      dap_adapters = {},
      dap_configurations = {},
      _initialize_lazy = {
        debugger = function(opts)
          local Promise = require("promise")
          return Promise.new(function(resolve)
            for adapter_name, adapter in pairs(opts.dap_adapters or {}) do
              require("dap").adapters[adapter_name] = adapter
            end
            for configuration_name, configuration in pairs(opts.dap_configurations or {}) do
              require("dap").configurations[configuration_name] = configuration
            end
            resolve()
          end)
        end
      },
      _initialize = {
        debugger = function(plug, opts)
          for adapter_name, adapter in pairs(opts.dap_adapters or {}) do
            require("dap").adapters[adapter_name] = adapter
          end
          for configuration_name, configuration in pairs(opts.dap_configurations or {}) do
            require("dap").configurations[configuration_name] = configuration
          end
        end
      }
    }
  },
  {
    -- DAP
    'mfussenegger/nvim-dap',
    event = "VeryLazy",
    dependencies = { },
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
  {
      -- DAP UI
      'rcarriga/nvim-dap-ui',
      dependencies = { {'mfussenegger/nvim-dap' }, { 'nvim-neotest/nvim-nio' } },
      lazy = true,
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
}
