return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {},
    opts = {
      treesitter_install = {
        html = true
      },
      formatters = {
        ["html"] = function() return { require"formatter.filetypes.html".prettierd } end,
      },
    }
  }
}
