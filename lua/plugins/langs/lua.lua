return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {},
    opts = {
      mason_install = {
        ["lua_ls"] = true,
        ["stylua"] = true,
      },
      treesitter_install = {
        lua = true
      },
      formatters = {
        ["lua"] = function() return { require"formatter.filetypes.lua".stylua } end,
      },
      servers = {
        lua_ls = {}
      }
    }
  },
}
