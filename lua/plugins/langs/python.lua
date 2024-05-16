
return {
  {

    'neovim/nvim-lspconfig',
    dependencies = {},
    opts = {
      mason_install = {
        ["pylsp"] = true,
        ["black"] = true,
        ["isort"] = true,
        ["debugpy"] = true,
        ["flake8"] = true,
      },
      treesitter_install = {
        python = true,
      },
      formatters = {
        ["python"] = function() return { 
          require"formatter.filetypes.python".isort,
          require"formatter.filetypes.python".black 
        } end,
      },
      linters = {
        ["python"] = { "flake8" },
      },
      dap_adapters = {
        python = {
          type = 'executable',
          command = 'debugpy-adapter'
        },
      },
      dap_configurations = {
        python = {
          {
            type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = 'launch',
            name = 'Python: Launch file',
            program = '${file}',
            pythonPath = venv_path
                and ((vim.fn.has('win32') == 1 and venv_path .. '/Scripts/python') or venv_path .. '/bin/python')
              or nil,
            console = 'integratedTerminal',
          },
        },
      },
      servers = {
        pylsp = {}
      },
    },
  },
}
