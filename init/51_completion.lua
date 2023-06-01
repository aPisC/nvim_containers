local cmp = require'cmp'

-- Check if there's a word before the cursor (used by <TAB> mapping)
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local get_current_line = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
end
-- Send feed keys with special codes (used by <S-TAB> mapping)
local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end


  cmp.setup({
    experimental = {
      ghost_text = false,
    },
    completion = {
      -- autocomplete = true,
      autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },
      keyword_length = 2,
      -- completeopt = 'menu,preview,noinsert',
    },
    snippet = {
      expand = function(args) vim.fn["vsnip#anonymous"](args.body) end,
    },
    window = { },
    mapping = cmp.mapping.preset.insert({
      ['<C-d>'] = cmp.mapping.scroll_docs(4),
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ["<CR>"] = cmp.mapping.confirm({ select = false }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif vim.fn["vsnip#jumpable"](1) == 1 then                                                                                                 
          feedkey("<Plug>(vsnip-jump-next)", "")                                                                                                      
        elseif vim.fn["vsnip#available"]() == 1 and get_current_line():match("^[%s%a]*$") ~= nil then                                                                                                  
          feedkey("<Plug>(vsnip-expand-or-jump)", "")                                                                                                 
        elseif has_words_before() then                                                                                                                
          cmp.complete()                                                                                                                              
        else
          fallback()
        end
      end, {'i', 's'}),
      ["<Esc>"] = function(fallback)
        if cmp.visible() then
          cmp.close()
        else
          fallback()
        end
      end,
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.fn["vsnip#jumpable"](-1) == 1 then                                                                                                 
          feedkey("<Plug>(vsnip-jump-prev)", "")                                                                                                      
        else
          fallback()
        end
      end, {'i', 's'}),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['.'] = function(fallback)
        if cmp.visible() and cmp.get_active_entry() ~= nil then
          cmp.confirm()
          feedkey(".", "")
        else
          fallback()
        end
      end,
    }),
    sources = cmp.config.sources(
      {
        { name = 'nvim_lsp_signature_help' },
      }, 
      {
        { name = 'nvim_lsp' },
        { name = 'vsnip' }, 
        { name = 'calc' },
      },
      {
        { name = 'buffer' },
      }
    )
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
