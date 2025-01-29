return {
  -- {
  --   'WhoIsSethDaniel/mason-tool-installer.nvim',
  --   opts = function(plug, opts)
  --     opts.ensure_installed["yaml-language-server"] = true
  --     return opts
  --   end,
  -- },
  -- {
  --   "neovim/nvim-lspconfig",
  --   dependencies = {
  --     "someone-stole-my-name/yaml-companion.nvim",
  --     "nvim-lua/plenary.nvim",
  --   },
  --   opts = function(plug, opts)
  --     opts.servers.yamlls = require("yaml-companion").setup({
  --     })
  --     return opts
  --   end,
  -- },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = function(plug, opts)
      opts.ensure_installed["yaml-language-server"] = true
      return opts
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(plug, opts)
      opts.servers.helm_ls = {
        filetypes = {"helm", "yaml" },
        cmd = {"helm_ls", "serve"},
      }
      return opts
    end,
  },
}
