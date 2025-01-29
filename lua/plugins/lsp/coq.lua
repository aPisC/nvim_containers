function initialize_completion()
  vim.g.coq_settings = {
    auto_start = 'shut-up',
    completion = {
      skip_after = {"{", "}", "[", "]", "(", ")", " ", ","}
    },
    clients = {
      lsp = {
        short_name = "LSP",
        resolve_timeout = 0.5,
        always_on_top = {},
        weight_adjust = 1,

      },
      lsp_inline = {
        short_name = "LSPi",
        resolve_timeout = 0.5,
        always_on_top = {},
        weight_adjust = 0.8,

      }

    },
    limits = {
      completion_auto_timeout = 0.766,
      completion_manual_timeout = 1.566,
    },
    display = {
      mark_applied_notify = false,
      statusline = {
        helo = false
      },
      preview = {
        border = {
          {"", "NormalFLoat"},
          {"", "NormalFLoat"},
          {"", "NormalFLoat"},
          {" ", "NormalFLoat"},
          {"", "NormalFLoat"},
          {"", "NormalFLoat"},
          {"", "NormalFLoat"},
          {" ", "NormalFLoat"},
        },

      },
      icons = {
        mode ='short',
        mappings= {
          -- "Text", "Method", "Function", "Constructor", "Field", "Variable", "Class", "Interface", "Module", "Property", "Unit", "Value", "Enum", "Keyword", "Snippet", "Color", "File", "Reference", "Folder", "EnumMember", "Constant", "Struct", "Event", "Operator", "TypeParameter",
          Text = "󰊄",
          Method = "",
          Function = "",
          Constructor = "",
          Field = "",
          Variable = "",
          Class = "",
          Interface = "",
          Module = "",
          Property = "",
          Unit = " ",
          Value = "󰫧",
          Enum = "",
          Keyword = "",
          Snippet = "",
          Color = "",
          File = "",
          Reference = "",
          Folder = "",
          EnumMember = "",
          Constant = "",
          Struct = "",
          Event = "",
          Operator = "",
          TypeParameter = "",
        }

      },
      pum = {
        fast_close = false,
        kind_context = {" ", " "},
        source_context = {" ", " "},
      }
    },
    keymap = {
      recommended = false,
    },
    -- match = { },
  }
  vim.api.nvim_set_keymap('i', '<Esc>', [[pumvisible() ? "\<C-e>" : "\<Esc>"]], { expr = true, silent = true })
  vim.api.nvim_set_keymap('i', '<C-c>', [[pumvisible() ? "\<C-e><C-c>" : "\<C-c>"]], { expr = true, silent = true })
  vim.api.nvim_set_keymap('i', '<BS>', [[pumvisible() ? "\<C-e><BS>" : "\<BS>"]], { expr = true, silent = true })
  vim.api.nvim_set_keymap(
  "i",
  "<CR>",
  [[pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"]],
  { expr = true, silent = true }
  )

  local tabpresstime = vim.call("reltime")
  vim.keymap.set('i', '<Tab>', function()
    local copilot_suggestions_available, copilot_suggestions = pcall(require, "copilot.suggestion")
    if copilot_suggestions_available and copilot_suggestions.is_visible() then
      local delay = vim.call("reltimefloat", vim.call("reltime", tabpresstime))
      if delay < 0.5 then
        copilot_suggestions.accept()
      else
        copilot_suggestions.accept_word()
      end
      tabpresstime = vim.call("reltime")
    elseif vim.fn.pumvisible() then
      vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-n>", true, true, true), "n")
    else
      vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n")
    end
  end ,
  { }
  )
  vim.api.nvim_set_keymap('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<BS>"]], { expr = true, silent = true })


  require("coq_3p") {
    { src = "bc", short_name = "MATH", precision = 6 },
  }

  vim.cmd [[COQnow]]
end

return {
  {
     'github/copilot.vim',
     enabled = true,
     init = function()
       vim.g.copilot_filetypes = {
         sh=false,
       }
     end
  },
  {
    "neovim/nvim-lspconfig", -- REQUIRED: for native Neovim LSP integration
    dependencies = {
      "ms-jpq/coq_nvim",
      { "ms-jpq/coq.artifacts", branch = "artifacts" },
      { 'ms-jpq/coq.thirdparty', branch = "3p" },
    },
    opts = {
      _initialize = {
        completion = initialize_completion,
      }
    }
  },
}
