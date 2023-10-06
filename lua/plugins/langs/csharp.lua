local M = {
  {'Issafalcon/neotest-dotnet' },
  {
    'nvim-neotest/neotest',
    opts = function(plug, opts)
      table.insert(opts.adapters, require"neotest-dotnet")
      return opts
    end,
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = function(plug, opts)
      table.insert(opts.ensure_installed, "clang-format")
      return opts
    end,
  },

  {
    'williamboman/mason-lspconfig.nvim',
    opts = function(plug, opts)
      table.insert(opts.ensure_installed, "omnisharp")
      return opts
    end,
  },
  {'Hoffs/omnisharp-extended-lsp.nvim'},
  {

    'neovim/nvim-lspconfig',
    deps = { {'Hoffs/omnisharp-extended-lsp.nvim'} },
    opts = function(plug, opts)
      opts.servers.omnisharp = {
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
      }
      return opts
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(plug, opts)
      table.insert(opts.ensure_installed, "c_sharp")
      return opts
    end,
  },
  {
    'mhartington/formatter.nvim',
    opts = function(plug, opts)
      opts.autoformat["cs"] = true
      opts.filetype["cs"] = {
        { require"formatter.filetypes.cs".clangformat }
      }
      return opts
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(plug, opts)
      table.insert(opts.ensure_installed, "coreclr")
      opts.handlers["coreclr"] = function(config)
        require("mason-nvim-dap").default_setup(config)
        require("mason-nvim-dap").default_setup({
          name="netcoredbg",
          adapters=config.adapters
        })
      end
      return opts
    end,
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
