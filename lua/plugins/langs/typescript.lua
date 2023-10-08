return {
  {
    'mhartington/formatter.nvim',
    opts = function(plug, opts)
      opts.filetype.typescript =
        { require"formatter.filetypes.typescriptreact".prettierd }
      opts.filetype.typescriptreact =
        { require"formatter.filetypes.typescriptreact".prettierd }

      return opts
    end
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(plug, opts)
      opts.servers.tsserver = {}
      return opts
    end,
  },

}
