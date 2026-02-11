return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      mason_install = {
        eslint_d = true,
        prettierd = true,
        vtsls = true,
      },
      servers = {
        vtsls = {},
      },
      formatters = {
        ["typescript"] = function() return { require"formatter.filetypes.typescriptreact".prettier } end,
        ["typescriptreact"] = function() return { require"formatter.filetypes.typescriptreact".prettier } end,
      },
      linters = {
        tyescript = {"eslintd"},
        tyescriptreact = {"eslintd"},
      }
    },
  },
  -- {
  --   'tpope/vim-commentary',
  --   opts = {
  --     commentstring = {
  --       typescriptreact='{/* %s */}'
  --     }
  --   }
  -- },
  {
    "pmizio/typescript-tools.nvim",
    enabled = false,
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
