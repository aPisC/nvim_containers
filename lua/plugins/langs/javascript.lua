return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {},
    opts = {
      treesitter_install = {
        javascript = true
      },
      formatters = {
        javascript = function() return { require"formatter.filetypes.javascriptreact".prettierd } end,
        javascriptreact = function() return { require"formatter.filetypes.javascriptreact".prettierd } end,
      },
    }
  }
}
