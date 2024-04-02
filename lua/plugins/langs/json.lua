return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = function(_, opts)
      opts.ensure_installed["json-lsp"] = true
      return opts
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed.json = true
      return opts
    end,
  },
  {
    'mhartington/formatter.nvim',
    opts = function(plug, opts)
      opts.filetype.json = 
        { require"formatter.filetypes.json".prettierd }

      return opts
    end
  },
  {

    'neovim/nvim-lspconfig',
    dependencies = {},
    opts = function(_, opts)
      opts.servers.jsonls = {}
      return opts
    end,
  },
}
