local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- local lspkind_comparator = function(conf)
--   local lsp_types = require('cmp.types').lsp
--   return function(entry1, entry2)
--     if entry1.source.name ~= 'nvim_lsp' then
--       if entry2.source.name == 'nvim_lsp' then
--         return false
--       else
--         return nil
--       end
--     end
--     local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
--     local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

--     local priority1 = conf.kind_priority[kind1] or 0
--     local priority2 = conf.kind_priority[kind2] or 0
--     if priority1 == priority2 then
--       return nil
--     end
--     return priority2 < priority1
--   end
-- end

function initialize_completion(_, opts)
  local cmp = require("cmp")
  local lspkind = require("lspkind")
  local luasnip = require("luasnip")
  local copilot_suggestions_available, copilot_suggestions = pcall(require, "copilot.suggestion")

  luasnip.setup({})
  require("luasnip.loaders.from_vscode").lazy_load()
  require("luasnip.loaders.from_snipmate").lazy_load({paths = "./snippets"})
  require("luasnip.loaders.from_vscode").load({paths = "./snippets"})


  cmp.setup({
    sources =  vim.tbl_filter(
      function(source) return source end,
      vim.tbl_values(opts.cmp_sources)
    ),
    -- experimental = { ghost_text = { hl_group = "CmpGhostText" } },
    completion = {
      autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },
      keyword_length = 2,
      keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
      -- autocomplete = false,
      -- completeopt = 'menu,preview,noinsert,noselect',
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
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
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        -- compare.scopes,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        cmp.config.compare.locality,
        cmp.config.compare.kind,
        -- compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      }
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-d>'] = cmp.mapping.scroll_docs(4),
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ["<CR>"] = cmp.mapping(function(fallback)
        -- if cmp.visible() and luasnip.expandable() then
        --   luasnip.expand()
        -- elseif cmp.visible() and has_words_before() and cmp.get_selected_entry() ~=nil then
        if 
          cmp.visible() 
          -- and has_words_before() 
          and cmp.get_selected_entry() ~=nil
          and cmp.get_selected_entry().source.name ~= "nvim_lsp_signature_help"
        then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
        else
          fallback()
        end
      end),
      -- ["<Tab><Tab>"] = cmp.mapping(function(fallback)
      --   if copilot_suggestions_available and copilot_suggestions.is_visible() then
      --     copilot_suggestions.accept()
      --   elseif luasnip.expandable() then
      --     luasnip.expand()
      --   else
      --     fallback()
      --   end
      -- end, {'i', 's'}),
      ["<Tab>"] = (function()
        local tabpresstime = vim.call("reltime")

        return cmp.mapping(function(fallback)
          local copilotvim_success, copilotvim_suggestion = pcall(vim.fn["copilot#GetDisplayedSuggestion"])

          if false then
            -- elseif cmp.visible() and cmp.get_selected_entry() ~= nil then
            --   cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
          elseif copilotvim_success and copilotvim_suggestion.text then
            local delay = vim.call("reltimefloat", vim.call("reltime", tabpresstime))
            if delay < 0.5 then
               vim.fn["feedkeys"](vim.fn["copilot#Accept"](""))
            else
               vim.fn["feedkeys"](vim.fn["copilot#AcceptWord"](""))
            end
            tabpresstime = vim.call("reltime")
          elseif copilot_suggestions_available and copilot_suggestions.is_visible() then
            local delay = vim.call("reltimefloat", vim.call("reltime", tabpresstime))
            if delay < 0.5 then
              copilot_suggestions.accept()
            else
              copilot_suggestions.accept_word()
            end
            tabpresstime = vim.call("reltime")
          elseif cmp.visible() and has_words_before() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
          elseif luasnip.jumpable() then
            luasnip.jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, {'i', 's'})
      end)(),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if copilot_suggestions_available and copilot_suggestions.is_visible() then
          copilot_suggestions.accept_word()
        elseif cmp.visible() then
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
    }),

  })

  for ft, conf in pairs(opts.cmp_filetype) do
    local sources = vim.tbl_filter(
      function(source) return source end,
      vim.tbl_values(vim.tbl_deep_extend(
        "force", 
        {}, 
        conf.inherit and opts.cmp_sources or {},
        conf, 
        { inherit = false }
      ))
    )
 
    require("cmp").setup.filetype(ft, {sources=sources})
  end
  for cl, conf in pairs(opts.cmp_cmdline) do
    local sources = vim.tbl_filter(
      function(source) return source end,
      vim.tbl_values(conf)
    )
    require("cmp").setup.cmdline(
      cl,
      {
        mapping = require("cmp").mapping.preset.cmdline(),
        sources = sources
      }
    )
  end
end

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lsp',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'onsails/lspkind.nvim',
      "hrsh7th/cmp-emoji",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    opts = {
      _initialize = { completion = initialize_completion },
      cmp_sources = {
          signature_help = { group_index = 1, name = 'nvim_lsp_signature_help', priority = 200 },
          luasnip = { group_index = 1, name = 'luasnip', priority=150, max_item_count=5 },
          lsp = { group_index = 1, name = 'nvim_lsp', priority = 100 },
          emoji = { group_index = 1, name = 'emoji' },
          emoji = { group_inde = 2, name = 'emoji' },
          calc = { group_index = 2, name = 'calc' },
          buffer = { group_index = 2, name = 'buffer' },
      },
      cmp_filetype = {
        ["gitcommit"] = {
          cmp_git = { name = "cmp_git" },
          buffer = { name = "buffer" },
        }
      },
      cmp_cmdline = {
        [":"] = {
          path = { name = "path" },
          cmdline = { name = "cmdline" },
        },
        ["?"] = {
          buffer = { name = "buffer" },
        },
        ["/"] = {
          buffer = { name = "buffer" },
        },
      },
      extend_capabilities = {
        cmp = function(capabilities)

          return vim.tbl_deep_extend("force",
            require('cmp_nvim_lsp').default_capabilities(),
            capabilities,
            { textDocument={ completion={ completionItem={ snippetSupport=false}}}}
          )
        end
      }
    }
  },
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp"
  }
}
