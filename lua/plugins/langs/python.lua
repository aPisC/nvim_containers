
return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "pylsp")
      table.insert(opts.ensure_installed, "black")
      table.insert(opts.ensure_installed, "isort")
      return opts
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "python")
      return opts
    end,
  },
  {
    'mhartington/formatter.nvim',
    opts = function(_, opts)
      opts.filetype.python =
        {
          require"formatter.filetypes.python".isort,
          require"formatter.filetypes.python".black,
        }
      return opts
    end,
  },
  {

    'neovim/nvim-lspconfig',
    dependencies = {},
    opts = function(_, opts)
      opts.servers.pylsp = {}
      return opts
    end,
  },
}
