return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {  },
    opts = {
      mason_install = {
        ["tailwindcss"] = true
      },
      servers = {
        tailwindcss = {}
      }
    }
  }
}
