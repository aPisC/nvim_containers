local metals_au_group = vim.api.nvim_create_augroup("local-nvim-metals", { clear = true })


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
      -- formatters = {
      --   scala = function() return {
      --     function() return { ['exe']= 'scalafmt', ['args']= { '--stdin' }, ['stdin']= 1 } end
      --     -- function() vim.lsp.buf.format() end
      --   } end,
      -- },
      --
      efm = {
        -- scala = { "efmls-configs.formatters.scalafmt" } 
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
    },
    opts = {
      find_root_dir_max_project_nesting = 5,
      settings = {
        inlayHints = {
          hintsInPatternMatch = { enable = true },
          implicitArguments = { enable = true },
          implicitConversions = { enable = true },
          inferredTypes = { enable = true },
          typeParameters = { enable = true },
        },
        testUserInterface = "code lenses",
        -- testUserInterface = "Test Explorer",
        showInferredType=true,
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        superMethodLensesEnabled = true,
        enableSemanticHighlighting = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
        serverVersion = "1.5.1",
        serverProperties = {
          "-Xmx3G"
        },
      },
      init_options = {statusBarProvider = "on"},
    },
    config = function(plug, opts)
      local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")


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
            local has_dap, dap = pcall(require, "dap")
            if has_dap then
              require("metals").setup_dap()
            end
            if type(opts.on_attach) == "function" then
              opts.on_attach(client, bufnr)
            end
              vim.api.nvim_create_user_command("MetalsScalaTree", function()
                require("metals.tvp").toggle_tree_view()
              end, {})
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
