require"init.lsp"
 .ensure_lsp("omnisharp", {
  handlers = {
    ["textDocument/definition"] = require('omnisharp_extended').handler,
  },
 })
 .ensure_treesitter("c_sharp")


vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, { pattern = {"*.cs"}, callback=function()
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer=true})
  vim.keymap.set('n', '<F12>', vim.lsp.buf.definition, {buffer=true})
end})
