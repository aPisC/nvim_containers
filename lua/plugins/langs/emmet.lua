return {
  { 'aca/emmet-ls' },
  {
    'neovim/nvim-lspconfig',
    opts = function(plug, opts)
      opts.servers.emmet_ls = {
        filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' },
        capabilities = { textDocument = { completion = { completionItem = { snippetSupport = true } } } }
      }
      return opts
    end
  },
}
