return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {},
    opts = {
      treesitter_install = {
        javascript = true,
        typescript = true,
      },
      mason_install = {
        ["js-debug-adapter"] = true,
      },
      efm = {
         typescript = {
            "efmls-configs.formatters.prettier_d",
            "efmls-configs.linters.eslint_d",
         },
         typescriptreact = {
            "efmls-configs.formatters.prettier_d",
            "efmls-configs.linters.eslint_d",
         },
         javascript = {
            "efmls-configs.formatters.prettier_d",
            "efmls-configs.linters.eslint_d",
         },
         javascriptreact = {
            "efmls-configs.formatters.prettier_d",
            "efmls-configs.linters.eslint_d",
         },
      },
      formatters = {
        javascript = function() return { require"formatter.filetypes.javascriptreact".prettierd } end,
        javascriptreact = function() return { require"formatter.filetypes.javascriptreact".prettierd } end,
      },
      dap_adapters = {
        ["pwa-node"] = {
          host = "localhost",
          port = "${port}",
          type = "server",
          executable = {
            command = 'node',
            args = { vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}'  },
          },
        }
      }
    }
  },
  -- { 
  --   "mxsdev/nvim-dap-vscode-js", 
  --   dependencies = {
  --     'neovim/nvim-lspconfig',
  --     "mfussenegger/nvim-dap"
  --   },
  --   -- build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
  --   opts = {
  --     -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  --     -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
  --     -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  --     -- debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
  --     debugger_path = vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter',     
  --     debugger_cmd = { 'js-debug-adapter' },
  --     adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
  --     -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
  --     -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
  --     -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
  --   },
  -- },
  -- { 
  --   "microsoft/vscode-js-debug",
  --   lazy = true,
  --   build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
  -- }
}
