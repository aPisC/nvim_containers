return {
  {
    'williamboman/mason-lspconfig.nvim',
    opts = function(plug, opts)
      table.insert(opts.ensure_installed, "tailwindcss")
      return opts
    end,
  },
  {

    'neovim/nvim-lspconfig',
    dependencies = {  },
    opts = function(plug, opts)
      opts.servers.tailwindcss = {}
      return opts
    end,
  }
}
