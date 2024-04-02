return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = function(_, opts)
      opts.ensure_installed["stylua"] = true
      opts.ensure_installed["lua_ls"] = true
      return opts
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed.lua = true
      return opts
    end,
  },
  {
    'mhartington/formatter.nvim',
    opts = function(_, opts)
      -- opts.autoformat["lua"] = true
      opts.filetype["lua"] = {
        {
          exe = "stylua"
        }
      }
      return opts
    end,
  },
  {

    'neovim/nvim-lspconfig',
    dependencies = {},
    opts = function(_, opts)
      opts.servers.lua_ls = {}
      return opts
    end,
  },
}
