return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {},
    opts = {
      mason_install = {
        ["lua_ls"] = true,
        ["stylua"] = true,
      },
      treesitter_install = {
        lua = true
      },
      efm = {
        ["lua"] = { "efmls-configs.formatters.stylua" },
      },
      servers = {
        lua_ls = {}
      }
    }
  },
}
