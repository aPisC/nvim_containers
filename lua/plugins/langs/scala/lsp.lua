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
          -- function() return { ['exe']= 'scalafmt', ['args']= { '--stdin' }, ['stdin']= 1 } end
          function() vim.lsp.buf.format() end
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
              envFile = ".env",
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
      { "mfussenegger/nvim-dap" }
    },
    opts = {
      root_patterns=  {'.git'},
      settings = {
        -- testUserInterface = "code lenses",
        showInferredType=true,
        inlayHints = {
          byNameParameters = { enable = true },
          hintsInPatternMatch = { enable = true },
          implicitArguments = { enable = true },
          implicitConversions = { enable = true },
          inferredTypes = { enable = true },
          typeParameters = { enable = true },
        },
        enableSemanticHighlighting = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
        serverVersion = "1.6.2",
      },
      init_options = {statusBarProvider = "on"},
    },
    config = function(plug, opts)
      local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local has_dap, dap = pcall(require, "dap")


      -- patch metals handlers to use vim.ui
      local metals_handlers = require("metals.handlers")
      metals_handlers["metals/quickPick"] = function(_, result)
        local co = coroutine.running()

        vim.ui.select(result.items, {
          prompt = "Select an item:",
          format_item = function(item)
            return item.label
          end
        }, function(selected_item)
          if selected_item then
            coroutine.resume(co, { itemId = selected_item.id })
          else
            coroutine.resume(co, { cancelled = true })
          end
        end)

        return coroutine.yield(co)
      end

      metals_handlers["metals/inputBox"] = function(_, result)
        local co = coroutine.running()

        local args = { prompt = result.prompt }

        if result.value then
          args.default = result.value
        end

        vim.ui.input(args, function(input)
          if input == nil or input == "" then
            coroutine.resume(co, { cancelled = true })
          else
            coroutine.resume(co, { value = input })
          end
        end)

        return coroutine.yield(co)
      end

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
            vim.api.nvim_create_user_command("MetalsScalaTree", function()
              require("metals.tvp").toggle_tree_view()
            end, {})
          end,
        }
      )

      -- Start metals
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "*.scala", "*.sbt", "*.java" },
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
