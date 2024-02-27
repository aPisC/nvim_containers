local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end


return {
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
      {'onsails/lspkind.nvim'},
      {"hrsh7th/cmp-emoji"},
    },
    opts = function()
      local cmp = require("cmp")
      local copilot_suggestions_available, copilot_suggestions = pcall(require, "copilot.suggestion")
      local has_luasnip, luasnip = pcall(require, "luasnip")
      local has_lspkind, lspkind = pcall(require, "lspkind")

      return {
        -- experimental = { ghost_text = { hl_group = "CmpGhostText" } },
        completion = {
          -- autocomplete = false,
          autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },
          keyword_length = 2,
          keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
          -- completeopt = 'menu,preview,noinsert,noselect',
        },
        snippet = {
          expand = function(args)
            if has_luasnip then luasnip.lsp_expand(args.body) end
          end,
        },
        sources = cmp.config.sources(
        {
          { name = 'nvim_lsp_signature_help', priority = 200 },
          { 
            -- Non snippet lsp entries
            name = 'nvim_lsp', 
            priority = 100, 
            -- entry_filter = function(entry, ctx)
            --   return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Snippet'
            -- end
          },
          { name = 'emoji' },
          has_luasnip and { name = 'luasnip', priority=150 } or nil,
        },
        {
          { name = 'emoji' },
          { name = 'calc' },
          { name = 'buffer' },
        }
        ),
        formatting = has_lspkind and {
          format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            symbol_map = {
              Copilot = "",
              TypeParameter = "󰬛",
            }
          })
        } or nil,
        -- sorting = {
        --   priority_weight = 2,
        --   comparators = {
        --     cmp.config.compare.offset,
        --     -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
        --     cmp.config.compare.exact,
        --     cmp.config.compare.score,
        --     cmp.config.compare.recently_used,
        --     cmp.config.compare.locality,
        --     cmp.config.compare.kind,
        --     cmp.config.compare.sort_text,
        --     cmp.config.compare.length,
        --     cmp.config.compare.order,
        --   },
        -- },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() and has_words_before() and cmp.get_selected_entry() ~=nil then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
            else
              fallback()
            end
          end),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if false then
            -- elseif cmp.visible() and cmp.get_selected_entry() ~= nil then
            --   cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
            elseif copilot_suggestions_available and copilot_suggestions.is_visible() then
              copilot_suggestions.accept()
            elseif cmp.visible() and has_words_before() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, {'i', 's'}),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            elseif copilot_suggestions_available and copilot_suggestions.is_visible() then
              copilot_suggestions.accept_line()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
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
}
