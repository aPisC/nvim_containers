return {
  {
    'mhartington/formatter.nvim',
    opts = function(plug, opts)
      opts.filetype.json = 
        { require"formatter.filetypes.json".prettierd }

      return opts
    end
  },
}
