return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      formatters = {
        ["typescript"] = function() return { require"formatter.filetypes.typescriptreact".prettierd } end,
        ["typescriptreact"] = function() return { require"formatter.filetypes.typescriptreact".prettierd } end,
      },
    },
  },
  {
    'tpope/vim-commentary',
    opts = {
      commentstring = {
        typescriptreact='{/* %s */}'
      }
    }
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      settings = {
        expose_as_code_action = "all",
      }
    },
  },
}
