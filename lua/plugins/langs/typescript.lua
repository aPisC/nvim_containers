return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      mason_install = {
        eslint_d = true,
        prettierd = true,
      },
      formatters = {
        ["typescript"] = function() return { require"formatter.filetypes.typescriptreact".prettierd } end,
        ["typescriptreact"] = function() return { require"formatter.filetypes.typescriptreact".prettierd } end,
      },
      linters = {
        tyescript = {"eslintd"},
        tyescriptreact = {"eslintd"},
      }
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
        expose_as_code_action = {
          "organize_imports",
          "add_missing_imports"
        },
        code_lens = "off",
        disable_member_code_lens = true,
      }
    },
  },
}
