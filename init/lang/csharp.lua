require"init.lsp"
 .ensure_tool({"clang-format"})
 .ensure_lsp("omnisharp", {
   handlers = {
     ["textDocument/definition"] = require('omnisharp_extended').handler,
   },
   on_attach = function(client, bufnr)
      local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
      for i, v in ipairs(tokenModifiers) do
        tmp = string.gsub(v, ' ', '_')
        tokenModifiers[i] = string.gsub(tmp, '-_', '')
      end
      local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
      for i, v in ipairs(tokenTypes) do
        tmp = string.gsub(v, ' ', '_')
        tokenTypes[i] = string.gsub(tmp, '-_', '')
      end
   end
 })
 -- .ensure_lsp("csharp_ls", {
 --   handlers = {
 --    ["textDocument/definition"] = require('csharpls_extended').handler,
 --   },
 -- })
 .ensure_treesitter("c_sharp")
 .ensure_dap("coreclr", function(config)
    require('mason-nvim-dap').default_setup(config) 
    require"init.utils".print(config)
 end)
 .set_formatter(
   {"cs"},
   { require"formatter.filetypes.cs".clangformat }
 )


vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, { pattern = {"*.cs"}, callback=function()
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer=true})
  vim.keymap.set('n', '<F12>', vim.lsp.buf.definition, {buffer=true})
end})

vim.api.nvim_create_autocmd("FileType", {
  pattern="cs",
  command="setlocal shiftwidth=4 softtabstop=4 expandtab"
})

vim.api.nvim_create_autocmd("FileType", {pattern="cs", command="setlocal commentstring=//\\ %s"})

require("nvim-web-devicons").set_icon {
  cs = {
    icon = "󰌛",
    color = "#596706",
    name = "CSharp"
  }
}
