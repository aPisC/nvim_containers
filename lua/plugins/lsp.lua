local SymbolKind = vim.lsp.protocol.SymbolKind

return {
  {
    -- LSP config
    'neovim/nvim-lspconfig',
    dependencies = {
        -- { "jubnzv/virtual-types.nvim" },
        { 'ray-x/lsp_signature.nvim' }
    },
    opts = {
      servers = {},
      capabilities = {
        -- use_virtual_types = true, -- Czzustom flag for auto attaching virtual types
        signature_help = {
          enable = true,
          bind = true, -- This is mandatory, otherwise border config won't get registered.
          handler_opts = { border = "rounded" },
          hint_enable = false,
        },
      },
    },
    config = function(plug, opts)
      local lspconfig = require("lspconfig")
      for server, server_config in pairs(opts.servers) do
        local capabilities = vim.tbl_deep_extend( "force",
          {},
          vim.lsp.protocol.make_client_capabilities(),
          require("cmp_nvim_lsp").default_capabilities(),
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

      vim.keymap.set('n', '<F12>', function() vim.cmd("Telescope lsp_definitions") end)
      vim.keymap.set('n', '<F24>', function() vim.cmd("Telescope lsp_references") end)
      vim.keymap.set('n', 'gd', function() vim.cmd("Telescope lsp_definitions") end)
      vim.keymap.set('n', 'gr', function() vim.cmd("Telescope lsp_references") end)
      vim.keymap.set('n', 'gi', function() vim.cmd("Telescope lsp_implementations") end)
      vim.keymap.set('n', '<F2>', vim.lsp.buf.rename)
      -- if not vim.fn.mapcheck("<M-CR>", "n") then
        vim.keymap.set('n', '<M-CR>', vim.lsp.buf.code_action )
      -- end
      vim.keymap.set('n', 'K', vim.lsp.buf.hover)
      vim.keymap.set('n', '<C-g>e', vim.diagnostic.goto_next)
      vim.keymap.set('i', '<C-?>', function() vim.lsp.buf.signature_help() end, { silent = true, noremap = true, desc = 'toggle signature' })


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
  { 
    'VidocqH/lsp-lens.nvim',
    opts = {
      enable = true,  
      include_declaration = false,     
      sections = {                      -- Enable / Disable specific request, formatter example looks 'Format Requests'
        definition = false,
        references = true,
        implements = false,
        git_authors = true,
      },
      target_symbol_kinds = { SymbolKind.Function, SymbolKind.Method, SymbolKind.Interface, SymbolKind.Module, SymbolKind.Class, SymbolKind.Struct, SymbolKind.Enum, SymbolKind.Interface },
      wrapper_symbol_kinds = { SymbolKind.Class, SymbolKind.Struct, SymbolKind.Package, SymbolKind.Module, SymbolKind.Namespace }
    }
  },
  {
    'kosayoda/nvim-lightbulb',
    enabled=false,
    opts = {
      autocmd = {enabled = true},
      ignore = {
        clients = {},
      },
    }
  },
  {

    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
    opts = true
    -- install jsregexp (optional!).
    -- 	build = "make install_jsregexp"
  },
  {
    -- DAP
    'mfussenegger/nvim-dap',
    keys = {
      {'<F5>', function() require("dap").continue() end, mode={'n', 'i'}},
      {'<F17>', function() require("dap").terminate() end, mode={'n', 'i'}},
      {'<F9>', function() require("dap").toggle_breakpoint() end, mode={'n', 'i'}},
      {
        '<F21>',
        function()
          local condition = vim.fn.input("Condition: ")
          if condition ~= "" then
            require("dap").set_breakpoint(condition)
            return
          end

          local logMessage = vim.fn.input("Log message: ")
          if logMessage ~= "" then
            require("dap").set_breakpoint(nil, nil, logMessage)
            return
          end

          require("dap").set_breakpoint()
        end,
        mode={'n', 'i'}
      },
      {'<F10>', function() require("dap").step_over() end, mode={'n', 'i'}},
      {'<F11>', function() require("dap").step_into() end, mode={'n', 'i'}},
      {'<F23>', function() require("dap").step_out() end, mode={'n', 'i'}},
      {'<C-g>r', function() require("dap").repl.toggle({height=10}) end}
    },
    init = function()
      -- require("dap").defaults.fallback.switchbuf = "useopen"
    end,
  },
  {
    -- DAP UI
    'rcarriga/nvim-dap-ui',
    dependencies = { {'mfussenegger/nvim-dap' } },
    config = function(plug, opts)
      local dap = require("dap")
      require("dapui").setup(opts)

      vim.api.nvim_create_user_command("DapUi", function()
        vim.cmd(":Neotree action=close")
        require("dapui").toggle()
      end, {})
      vim.api.nvim_create_user_command("DapRun", function() require('dap').run() end, {})
      vim.api.nvim_create_user_command("DapRunLast", function() require('dap').run_last() end, {})
      vim.api.nvim_create_user_command("DapRepl", function() require('dap').repl.toggle({height=10}) end, {})

      dap.listeners.before['event_stopped']['dapui_event_handling'] = function(session, body)
        vim.cmd(":Neotree action=close")
        require("dapui").open()
      end
      dap.listeners.after['event_terminated']['dap-ui'] = function(session, body)
        if not body.restart then
          require("dapui").close()
        end
      end
      dap.listeners.after['terminated']['dap-ui'] = function(session, body)
        if not body.restart then
          require("dapui").close()
        end
      end
    end,
    opts = {
      layouts = {
        {
          elements = {
            {id = "breakpoints", size = 10},
            {id = "watches", size = 0.33},
            {id = "scopes", size = 0.33},
            -- "stacks",
          },
          size = 30,
          position = "left",
        },
        -- {
        --   elements = {
        --     "repl",
        --     -- "console",
        --   },
        --   size = 10,
        --   position = "bottom",
        -- },
      },
      icons = {
        collapsed = "",
        current_frame = "",
        expanded = ""
      },
      controls = {
        element = "scopes",
      },
      expand_lines = false,
    }
  },
  {
    -- Neotest
    'nvim-neotest/neotest',
    dependencies = {
      {'nvim-treesitter/nvim-treesitter'},
      {'antoinemadec/FixCursorHold.nvim'},
      { 'nvim-lua/plenary.nvim'},
    },
    opts = function() return {
      adapters = { },
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
    } end,
    config = function(plug, opts)
      require("neotest").setup(opts)

      vim.api.nvim_create_user_command('TestStop', function() require("neotest").run.stop() end, {})
      vim.api.nvim_create_user_command('TestFile', function() require("neotest").run.run(vim.fn.expand("%")) end, {})
      vim.api.nvim_create_user_command('TestNearest', function() require("neotest").run.run() end, {})
      vim.api.nvim_create_user_command('TestLast', function() require("neotest").run.run() end, {})
      vim.api.nvim_create_user_command('TestSummary', function() require("neotest").summary.toggle() end, {})
    end
  },
  {
    -- Treesitter
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = { },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        disable = { "lua", "help" },
        additional_vim_regex_highlighting = true,
      },
    },
    config = function(plug, opts)
      require("nvim-treesitter.configs").setup(opts)
    end
  },
  {
    -- Formatter
    'mhartington/formatter.nvim',
    opts = function (plug, opts) return {
      logging = false,
      log_level = vim.log.levels.WARN,
      autoformat = { },
      filetype = {
        ["*"] = {
          require("formatter.filetypes.any").remove_trailing_whitespace
        }
      },
    } end,
    config = function(plug, opts)
      local formatter = require("formatter").setup(opts)

      -- Configure autoformat
      local autoformatgroup = vim.api.nvim_create_augroup("Autoformat", {})
      -- for ft, autoformat in pairs(opts.autoformat) do
      --   if type(autoformat) == "function" then
      --     vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      --       pattern = { "*." .. ft },
      --       group = autoformatgroup,
      --       callback = function()
      --         if autoformat() then
      --           vim.cmd("FormatWrite")
      --         end
      --       end
      --     })
      --   elseif autoformat then
      --     vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      --       pattern = { "*." .. ft },
      --       group = autoformatgroup,
      --       callback = function()
      --         print("Formatting")
      --         vim.cmd("FormatWrite")
      --       end
      --     })
      --   end
      -- end
    end,
  },
  {
    -- Mason
    'williamboman/mason.nvim',
    config=true,
    priority=60,
  },
  {
    -- Mason
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {

      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
    }
  },
  {
    -- Mason
    'williamboman/mason-lspconfig.nvim',
    opts = {
      ensure_installed = {},
      automatic_installion = true,
    },
  },
  {
    -- Mason
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { },
      handlers = { }
    }
  },
    -- LspKind
  {
    'onsails/lspkind.nvim',
    config = function(plug, opts) end
  },
  {
    -- Completion
    'hrsh7th/nvim-cmp',
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp-signature-help'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-calc'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'hrsh7th/cmp-cmdline'},
    },
    opts = function()
      local cmp = require("cmp")
      local copilot_suggestions_available, copilot_suggestions = pcall(require, "copilot.suggestion")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      return {
        experimental = { ghost_text = { hl_group = "CmpGhostText" } },
        completion = {
          autocomplete = false,
          -- autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },
          keyword_length = 3,
          keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
          -- completeopt = 'menu,preview,noinsert', a
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        sources = cmp.config.sources(
          {
            { name = 'nvim_lsp_signature_help', priority = 200 },
            { name = 'nvim_lsp', priority = 100 },
            { name = 'luasnip', priority=1 },
          },
          {
            { name = 'calc' },
            { name = 'buffer' },
          }
        ),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            symbol_map = {
              Copilot = "",
              TypeParameter = "󰬛",
            }
          })
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.offset,
            -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if copilot_suggestions_available and copilot_suggestions.is_visible() then
              copilot_suggestions.accept_word()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif cmp.visible() then
              cmp.select_next_item()
              -- elseif vim.fn["vsnip#available"]() == 1 and get_current_line():match("^[%s%a]*$") ~= nil then
              -- elseif has_words_before() then
              --   cmp.complete()
            else
              fallback()
            end
          end, {'i', 's'}),
          ["<Esc>"] = function(fallback)
            if copilot_suggestions_available and copilot_suggestions.is_visible() then
            copilot_suggestions.dismiss()
            elseif cmp.visible() then
              cmp.close()
            else
              fallback()
            end
          end,
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if copilot_suggestions_available and copilot_suggestions.is_visible() then
              copilot_suggestions.accept_line()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            elseif cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, {'i', 's'}),
          -- ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-Space>'] = function(fallback)
            cmp.complete()
            if copilot_suggestions_available and copilot_suggestions.is_visible() then
              copilot_suggestions.dismiss()
            end
          end,
          -- ['.'] = function(fallback)
          --   if cmp.visible() and cmp.get_active_entry() ~= nil then
          --     cmp.confirm()
          --     feedkey(".", "")
          --   else
          --     fallback()
          --   end
          -- end,
        }),
        filetype = {
          ["gitcommit"] = {
            sources = { {name="cmp_git"}, { name = "buffer" } }
          }
        },
        cmdline = {
          [":"] = {
            mapping = require("cmp").mapping.preset.cmdline(),
            sources = { {name = 'path'}, {name = 'cmdline'} }
          },
          ["?"] = {
            mapping = require("cmp").mapping.preset.cmdline(),
            sources = { {name = 'buffer'} }
          },
          ["/"] = {
            mapping = require("cmp").mapping.preset.cmdline(),
            sources = { {name = 'buffer'} }
          },
        }
      }
    end,
    config = function(plug, opts)
      require("cmp").setup(opts)
      for ft, conf in pairs(opts.filetype) do
        require("cmp").setup.filetype(ft, conf)
      end
      for cl, conf in pairs(opts.cmdline) do
        require("cmp").setup.cmdline(ft, conf)
      end
    end
  },
}
