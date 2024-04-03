local metals_au_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'aPisC/neotest-scala'
    },
    opts = {
      treesitter_install = {
        scala = true
      },
      formatters = {
        scala = function() return { 
          function() return { ['exe']= 'scalafmt', ['args']= { '--stdin' }, ['stdin']= 1 } end
        } end,
      },
      test_adapters = {
        ["scala"] = function() return require("neotest-scala")({
          runner = "sbt",
          framework = "scalatest"
        }) end,
      },
      dap_configurations = {
        scala = {
          {
            type = 'scala',
            request = 'launch',
            name = 'Run or Test Target',
            metals = {
              runType = "runOrTestFile",
            },
          },
        },
      },
    }
  },
  {
    'scalameta/nvim-metals',
    dependencies = { 
      { 'nvim-lua/plenary.nvim' },
      { 'jubnzv/virtual-types.nvim' },
    },
    opts = {
      -- root_patterns=  {'.git'},
      settings = {
        testUserInterface = "code lenses",
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        superMethodLensesEnabled = true,
        showInferredType=true,
        enableSemanticHighlighting = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
        serverVersion = "1.2.2",
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
    end,
  },

}
