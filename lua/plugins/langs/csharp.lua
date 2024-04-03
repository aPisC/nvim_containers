local M = {
  {
    'neovim/nvim-lspconfig',
    dependencies = { 
      {'Hoffs/omnisharp-extended-lsp.nvim'},
      {'Issafalcon/neotest-dotnet' },
    },
    opts = {
      mason_install = {
        ["clang-format"] = true,
        ["omnisharp"] = true,
        ["netcoredbg"] = true,
      },
      treesitter_install = {
        ["c_sharp"] = true,
      },
      formatters = {
        ["cs"] = function() return { require"formatter.filetypes.cs".clangformat } end,
      },
      test_adapters = {
        ["dotnet"] = function() return require"neotest-dotnet" end,
      },
      debuggers = {
        ["coreclr"] = function(config)
          require("mason-nvim-dap").default_setup(config)
          require("mason-nvim-dap").default_setup({
            name="netcoredbg",
            adapters=config.adapters
          })
        end
      },
      servers = {
        omnisharp = function() return {
          cmd = { "omnisharp" },
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
        } end,
      },
    },
  },
  -- {
  --   "jay-babu/mason-nvim-dap.nvim",
  --   opts = function(plug, opts)
  --     table.insert(opts.ensure_installed, "coreclr")
  --     opts.handlers["coreclr"] = function(config)
  --       require("mason-nvim-dap").default_setup(config)
  --       require("mason-nvim-dap").default_setup({
  --         name="netcoredbg",
  --         adapters=config.adapters
  --       })
  --     end
  --     return opts
  --   end,
  -- },
}

-- Other configs
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

return M
