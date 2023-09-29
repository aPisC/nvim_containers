return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = function(plug, opts)
      table.insert(opts.ensure_installed, "stylua")
      return opts
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(plug, opts)
      table.insert(opts.ensure_installed, "lua")
      return opts
    end,
  },
  {
    'mhartington/formatter.nvim',
    opts = function(plug, opts)
      opts.autoformat["lua"] = true
      opts.filetype["lua"] = {
        { require"formatter.filetypes.lua".stylua }
      }
      return opts
    end,
  },
}
