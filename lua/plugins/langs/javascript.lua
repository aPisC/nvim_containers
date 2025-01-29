return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {},
    opts = {
      treesitter_install = {
        javascript = true
      },
      formatters = {
        javascript = function() return { require"formatter.filetypes.javascriptreact".prettierd } end,
        javascriptreact = function() return { require"formatter.filetypes.javascriptreact".prettierd } end,
      },
      -- dap_adapters = {
      --   node = {
      --     type = 'executable',
      --     command = 'js-debug-adapter'
      --   },
      -- },
    }
  },
  { 
    "mxsdev/nvim-dap-vscode-js", 
    dependencies = {
      'neovim/nvim-lspconfig',
      "mfussenegger/nvim-dap"
    },
    -- build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
    opts = {
      debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"
    },
  },
  { 
    "microsoft/vscode-js-debug",
    lazy = true,
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
  }
}
