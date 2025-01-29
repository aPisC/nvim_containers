function initialize_mason(plug, opts)
  require("mason").setup({})
  require("mason-tool-installer").setup({
    ensure_installed = vim.tbl_filter(
      function(package) return opts.mason_install[package] end,
      vim.tbl_keys(opts.mason_install)
    ),
    auto_update = false,
    run_on_start = true,
    start_delay = 3000,
  })
  require("mason-lspconfig").setup({
    ensure_installed = {},
    automatic_installion = true,
  })
  -- require("mason-nvim-dap").setup({
  --   ensure_installed = {},
  --   handlers = opts.debuggers,
  -- })
end

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'williamboman/mason-lspconfig.nvim',
      -- "jay-babu/mason-nvim-dap.nvim",
    },
    opts = {
    }
  }

}


