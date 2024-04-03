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
      dap_adapters = {
        netcoredbg =  {
          type = 'executable',
          command = "netcoredbg",
          args = { '--interpreter=vscode' },
        },
      },
      dap_configurations = {
        cs = {
          {
            type = 'coreclr',
            name = 'NetCoreDbg: Launch',
            request = 'launch',
            cwd = '${fileDirname}',
            program = function ()
              return coroutine.create(function(dap_run_co)
                local items = vim.fn.globpath(vim.fn.getcwd(), '**/bin/Debug/**/*.dll', 0, 1)
                local opts = {
                  format_item = function(path)
                    return vim.fn.fnamemodify(path, ':t')
                  end,
                }
                local function cont(choice)
                  if choice == nil then
                    return nil
                  else
                    coroutine.resume(dap_run_co, choice)
                  end
                end

                vim.ui.select(items, opts, cont)
              end)
            end,
          },
        }
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
