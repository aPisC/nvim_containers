return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      mason_install = {
        ["emmet-language-server"] = true,
      },
      servers = {
        emmet_language_server = {}
      }
    }
  }
}
