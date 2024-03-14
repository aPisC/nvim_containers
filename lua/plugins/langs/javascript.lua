return {
  {
    'mhartington/formatter.nvim',
    opts = function(plug, opts)
      opts.filetype.javascript =
        { require"formatter.filetypes.javascriptreact".prettierd }
      opts.filetype.javascriptreact =
        { require"formatter.filetypes.javascriptreact".prettierd }
      return opts
    end
  },
}
