return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {},
    opts = {
      modules = {
        terraform = {
          auto = false,
          lazy = true,
          mason_install = { ["terraform-ls"] = true },
          servers = { ["terraformls"] = {} },
        },
      }
    },
  },
}
