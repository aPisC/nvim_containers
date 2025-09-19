vim.filetype.add({
  pattern = {
    [".*/openapi/.*.yaml"] = "yaml.openapi"
  }
})

return {
  {

    'neovim/nvim-lspconfig',
    dependencies = {},
    opts = {
      mason_install = {
        ["yaml-language-server"] = true,
        -- ["yamllint"] = true
        ["vacuum"] = true,
      },
      treesitter_install = {
        yaml = true,
      },
      efm = {
        ["yaml"]         = { "efmls-configs.formatters.prettier_d" },
        ["yaml.openapi"] = { "efmls-configs.formatters.prettier_d" },
      },
      servers = {
        ["vacuum"] = {},
        ["yamlls"] = {
          settings = {
            yaml = {
              schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              }
            }
          }
        }
      },
    },
  },
}
