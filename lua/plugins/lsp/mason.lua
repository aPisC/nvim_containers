return {
  {
    -- Mason
    'williamboman/mason.nvim',
    config=true,
    priority=60,
  },
  {
    -- Tool for installing mason packages
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      ensure_installed = { },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
    },
    config = function(plug, opts)
      local mason = require('mason')
      local ensure_installed = { }
      for package, enabled in pairs(opts.ensure_installed) do
        if enabled then table.insert(ensure_installed, package) end
      end

      local config = vim.tbl_deep_extend("force", { ensure_installed = ensure_installed }, opts)
      mason.setup(config)
    end,
  },
  {
    -- Tool for installing DAP Adapters
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      ensure_installed = { },
      handlers = { }
    }
  },
  {
    -- Tool for installing LSP servers
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      ensure_installed = {},
      automatic_installion = true,
    },
  },
}

