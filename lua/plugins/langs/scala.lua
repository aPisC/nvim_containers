local metals_au_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })

return {
  -- LSP
  {
    'scalameta/nvim-metals',
    dependencies = { 
      { 'nvim-lua/plenary.nvim' },
      { 'jubnzv/virtual-types.nvim' },
    },
    opts = {
      -- root_patterns=  {'.git'},
      settings = {
        -- testUserInterface = "Test Explorer",
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
        serverVersion = "1.1.0",
        superMethodLensesEnabled = true,
      },
      init_options = {statusBarProvider = "on"},
    },
    config = function(plug, opts)
      local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local has_dap, dap = pcall(require, "dap")


      -- Create metals config
      local metals_capabilities = vim.tbl_deep_extend("force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities() or {},
        {
          workspace = {
            configuration = false
          }
        },
        opts.capabilities or {}
      )

      local metals_config = vim.tbl_deep_extend(
        "force", 
        require("metals").bare_config(),
        opts, 
        {
          capabilities = capabilities,
          on_attach = function(client, bufnr) 
            if has_dap then
              require("metals").setup_dap() 
            end
            if type(opts.on_attach) == "function" then
              opts.on_attach(client, bufnr)
            end
            require'virtualtypes'.on_attach(client, bufnr)
          end,
        }
      )

      -- Start metals
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt", "java" },
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = metals_au_group,
      })

      vim.api.nvim_create_user_command("MetalsAttachFile", function()
        require("metals").initialize_or_attach(metals_config)
      end, {})

      -- dap config
      if has_dap then
        dap.configurations.scala = {
          {
            type = "scala",
            request = "launch",
            name = "Run or Test Target",
            metals = {
              runType = "runOrTestFile",
            },
          }
        }
      end
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
          ['args']= { 
            -- '-c', 
            -- '/home/bendeguz/workspace/hiya/dliub/.scalafmt.conf',  
            '--stdin' 
          },
          ['stdin']= 1,
        } end,
      }
      return opts
    end
  }
}
