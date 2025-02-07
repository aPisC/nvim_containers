return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {},
    opts = {
      modules = {
        html = {
          lazy = false, auto = true,
          treesitter_install = {
            html = true
          },
          formatters = {
            ["html"] = function() return { require"formatter.filetypes.html".prettierd } end,
          },
        }
      }
    }
  }
}
