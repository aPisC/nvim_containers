return {
  {
    'mhartington/formatter.nvim',
    opts = function(plug, opts)
      opts.filetype.html =
        { require"formatter.filetypes.html".prettierd }
      return opts
    end
  },
}

