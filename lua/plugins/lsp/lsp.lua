
return {
  {
    -- LSP config
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'mrjones2014/legendary.nvim',
        opts = {
          ["nvim-lspconfig"] = {
            keymaps = {
               {'<F12>',  {n=":Telescope lsp_definitions<CR>"}, description="LSP Show definitions" },
               {'<F24>',  {n=":Telescope lsp_references<CR>"}, description="LSP Show references" },
               {'gd',     {n=":Telescope lsp_definitions<CR>"}, description="", hide=true },
               {'gr',     {n=":Telescope lsp_references<CR>"}, description="", hide=true },
               {'gi',     {n=":Telescope lsp_implementations<CR>"}, description="LSP Show implementations" },
               {'<F2>',   {n=vim.lsp.buf.rename}, description="LSP Rename symbol" },
               {'<M-CR>', {n=vim.lsp.buf.code_action, v=vim.lsp.buf.code_action, i=vim.lsp.buf.code_action }, description="LSP Code actions" },
               {'<M-S-CR>', {n=vim.lsp.codelens.run, v=vim.lsp.codelens.run, i=vim.lsp.codelens.run }, description="LSP Code actions" },
               {'K',      {n=vim.lsp.buf.hover}, description="LSP Hover" },
               {'<C-g>e', {n=vim.diagnostic.goto_next}, description="LSP Next diagnostic" },
               {'<C-?>',  {i=vim.lsp.buf.signature_help}, description="LSP Signature help" },
            }
          }
        }
      },
      'nvim-neotest/nvim-nio',
      'mhartington/formatter.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-lua/plenary.nvim',
      'williamboman/mason.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- "jay-babu/mason-nvim-dap.nvim",
      'williamboman/mason-lspconfig.nvim',
      'mfussenegger/nvim-dap',
    },
    opts = {
      mason_install =  {},
      treesitter_install = {},
      formatters = {
        ["*"] = function() return { require("formatter.filetypes.any").remove_trailing_whitespace } end
      },
      test_adapters = {},
      dap_adapters = {},
      dap_configurations = {},
      servers = {},

      capabilities = {
        -- use_virtual_types = true, -- Custom flag for auto attaching virtual types
        signature_help = {
          enable = false,
          bind = true, -- This is mandatory, otherwise border config won't get registered.
          handler_opts = { border = "rounded" },
          hint_enable = false,
        },
      },
    },
    config = function(plug, opts)
      -- Setup treesitter
      require("nvim-treesitter.configs").setup({
        ensure_installed = vim.tbl_filter(
          function(lang) return opts.treesitter_install[lang] end,
          vim.tbl_keys(opts.treesitter_install)
        ),
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          disable = { "lua", "help" },
          additional_vim_regex_highlighting = true,
        },
      })

      -- Setup mason
      require("mason").setup({})
      require("mason-tool-installer").setup({
        ensure_installed = vim.tbl_filter(
          function(package) return opts.mason_install[package] end,
          vim.tbl_keys(opts.mason_install)
        ),
        auto_update = false,
        run_on_start = true,
        start_delay = 3000,
      })
      -- require("mason-nvim-dap").setup({
      --   ensure_installed = {},
      --   handlers = opts.debuggers,
      -- })
      require("mason-lspconfig").setup({
        ensure_installed = {},
        automatic_installion = true,
      })

      -- Setup formatters
      require("formatter").setup({
        logging = false,
        log_level = vim.log.levels.WARN,
        filetype = vim.tbl_map(
          function(formatter)
            if type(formatter) == "function" then
              return formatter()
            else 
              return formatter
            end
          end,
          opts.formatters
        )
      }) 

      -- Setup test adapters
      require("neotest").setup({
        adapters = vim.tbl_values(vim.tbl_map(
          function(adapter)
            if type(adapter) == "function" then
              return adapter()
            else
              return adapter
            end
          end,
          opts.test_adapters
        )),
        icons = {
          running_animated = { "◜", "◜", "◝", "◝", "◞", "◞", "◟", "◟" },
        },
        summary = {
          mappings = {
            short = "o",
            output = "O",
            stop = "s",
          }
        },
      })
      vim.api.nvim_create_user_command('TestStop', function() require("neotest").run.stop() end, {})
      vim.api.nvim_create_user_command('TestFile', function() require("neotest").run.run(vim.fn.expand("%")) end, {})
      vim.api.nvim_create_user_command('TestNearest', function() require("neotest").run.run() end, {})
      vim.api.nvim_create_user_command('TestLast', function() require("neotest").run.run() end, {})
      vim.api.nvim_create_user_command('TestSummary', function() require("neotest").summary.toggle() end, {})

      -- setup Dap
      for adapter_name, adapter in pairs(opts.dap_adapters) do
        require("dap").adapters[adapter_name] = adapter
      end
      for configuration_name, configuration in pairs(opts.dap_configurations) do
        require("dap").configurations[configuration_name] = configuration
      end

      -- setup LSP servers
      local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local lspconfig = require("lspconfig")

      for server, server_config in pairs(opts.servers) do
        local capabilities = vim.tbl_deep_extend("force",
          {},
          vim.lsp.protocol.make_client_capabilities(),
          has_cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities() or {},
          opts.capabilities,
          server_config.capabilities or {}
        )

        local on_attach = function(client, bufnr)
          if server_config.on_attach then server_config.on_attach(client, bufnr) end
          if capabilities.signature_help.enable then
            require("lsp_signature").on_attach(capabilities.signature_help, bufnr)
          end
          -- if capabilities.use_virtual_types then
            -- require("virtual-types").on_attach(client, bufnr)
          -- end
        end

        if server_config.lspDefaultCapabilities == false then capabilities = server_config.capabilities end

        local config = vim.tbl_deep_extend("force", {}, server_config, { capabilities = capabilities, on_attach = on_attach })
        lspconfig[server].setup(config)
      end

      -- show diagnostic on CursorHold
      local augrp = vim.api.nvim_create_augroup("LspCursorHold", {})
      vim.api.nvim_create_autocmd("CursorHold", {
        pattern = { "*" },
        callback = function()
          vim.diagnostic.open_float()
        end,
        group = augrp,
      })
    end,
    init = function()
      vim.diagnostic.config({
        underline=true,
        severity_sort=true,
        float = true,
        update_in_insert = true,
      })
    end
  },
}
