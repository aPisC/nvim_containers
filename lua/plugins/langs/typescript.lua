return {
  {
    'mhartington/formatter.nvim',
    opts = function(plug, opts)
      opts.filetype.typescript =
        { require"formatter.filetypes.typescriptreact".prettierd }
      opts.filetype.typescriptreact =
        { require"formatter.filetypes.typescriptreact".prettierd }

      opts.autoformat["ts"] = true
      opts.autoformat["tsx"] = true

      return opts
    end
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
