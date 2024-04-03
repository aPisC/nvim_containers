return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {},
    opts = {
      mason_install = {
        ["json-lsp"] = true,
        ["prettierd"] = true
      },
      treesitter_install = {
        json = true
      },
      formatters = {
        ["json"] = function() return { require"formatter.filetypes.json".prettierd } end,
      },
      servers = {
        jsonls = {}
      }
    }
  },
}
