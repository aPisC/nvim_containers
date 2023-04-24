
 local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args) vim.fn["vsnip#anonymous"](args.body) end,
      -- expand = function() end
    },
    window = { },
    mapping = cmp.mapping.preset.insert({
       ["<CR>"] = cmp.mapping.confirm({ select = false }),
       -- ["<CR>"] = function(fallback)
       --   if cmp.visible() then
       --     cmp.confirm()
       --     cmp.close()
       --   else
       --     fallback()
       --   end
       -- end,
       ["<Tab>"] = function(fallback)
         if cmp.visible() then
           cmp.select_next_item()
         else
           fallback()
         end
       end,
       ["<Esc>"] = function(fallback)
         if cmp.visible() then
           cmp.close()
         else
           fallback()
         end
       end,
       ["<S-Tab>"] = function(fallback)
         if cmp.visible() then
           cmp.select_prev_item()
         else
           fallback()
         end
       end,
      ['<C-Space>'] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip', keyword_pattern = [[^\s*\w+$]], priority = 40 }, 
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
