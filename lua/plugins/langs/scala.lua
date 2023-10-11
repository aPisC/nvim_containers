local metals_au_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })

return {
  -- LSP
  {
    'scalameta/nvim-metals',
    opts = function()
      local capabilities = vim.tbl_deep_extend("force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities(),
        {
          workspace = {
            configuration = false
          }
        }
      )

      return {
        -- root_patterns=  {'.git'},
        settings = {
          testUserInterface = "Test Explorer",
          showImplicitArguments = true,
          showImplicitConversionsAndClasses = true,
          excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
          serverVersion = "1.0.1",
        },
        init_options = {statusBarProvider = "on"},
        capabilities = capabilities,
        on_attach = function(client, bufnr) require("metals").setup_dap() end,
      }
    end,
    config = function(plug, opts)
      local metals_config = vim.tbl_deep_extend(
        "force",
        require("metals").bare_config(),
        opts
      )

      require("metals").config = metals_config

      -- Start metals
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt", "java" },
        callback = function()
          local config = require("metals").config
          require("metals").initialize_or_attach(config)
        end,
        group = metals_au_group,
      })

      -- dap config
      require("dap").configurations.scala = {
        {
          type = "scala",
          request = "launch",
          name = "Run or Test Target",
          metals = {
            runType = "runOrTestFile",
          },
        }
      }
    end,
  },

  -- Neotest
  {
    'nvim-neotest/neotest',
    dependencies = { { 'aPisC/neotest-scala'} },
    opts = function(plug, opts)
      table.insert(opts.adapters,
        require("neotest-scala")({
          runner = "sbt",
          framework = "scalatest"
        })
      )
      return opts
    end
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(plug, opts)
      table.insert(opts.ensure_installed, 'scala')
      return opts
    end
  },

  -- Formatter
  {
    'mhartington/formatter.nvim',
    opts = function(plug, opts)
      opts.filetype.scala = {
        function() return {
          ['exe']= 'scalafmt',
          ['args']= { '-c', '/home/bendeguz/workspace/hiya/dliub/.scalafmt.conf',  '--stdin' },
          ['stdin']= 1,
        } end,
      }
      return opts
    end
  }
}
