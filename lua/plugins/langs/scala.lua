return {
  -- LSP
  {
    'scalameta/nvim-metals',
    opts = {
      -- root_patterns=  {'.git'},
      settings = {
        testUserInterface = "Test Explorer",
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
        serverVersion = "1.0.1",
      }, 
      init_options = {statusBarProvider = "on"},
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      on_attach = function(client, bufnr) require("metals").setup_dap() end,
    },
    config = function(plug, opts)
      local metals_config = vim.tbl_deep_extend("force", require("metals").bare_config(), opts)
      -- Start metals
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt", "java" },
        callback = function() 
          require("metals").initialize_or_attach(metals_config) 
        end,
        group = vim.api.nvim_create_augroup("nvim-metals", { clear = true }),
      })

      -- dap config
      require("metals").setup_dap()
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
  { 'aPisC/neotest-scala'},
  {
    'nvim-neotest/neotest',
    deps = { { 'aPisC/neotest-scala'} },
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
