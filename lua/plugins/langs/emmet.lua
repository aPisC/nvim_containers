return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      mason_install = {
        ["emmet_ls"] = true,
      },
      servers = {
        emmet_ls = {
          filetypes = {
            'html',
            'typescriptreact',
            'javascriptreact',
            'css',
            'sass',
            'scss',
            'less'
          },
          capabilities = { textDocument = { completion = { completionItem = { snippetSupport = true } } } }
        }
      }
    }
  }
}
