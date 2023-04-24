
vim.opt.shell="bash"
require("toggleterm").setup({
  start_in_insert = true,
  size = 5,
})

require("neogit").setup({
  disable_commit_confirmation = true,
  kind = "tab",
  commit_popup = {
    kind = "tab"
  },
  popup = {
    kind = "replace"
  }
})



require('barbecue').setup({
  theme='tokyonight',
  icons=false
})

require "lsp_signature".setup({
  close_timeout = 400,
  floating_window = true,
  padding = ' ',
  select_signature_key = "<C-k>",
})

require("autoclose").setup({ 
   options = {
      disable_when_touch = true,
   }
})

require("autoformat").setup({
  json=true,
  javascript=true,
  typescript=true,
  javascriptreact=true,
  typescriptreact=true,
  markdown=true,
})


require('auto-save').setup({
  enabled = true,
  debounce_delay = 135,
  callbacks = { -- functions to be executed at different intervals
		enabling = nil, -- ran when enabling auto-save
		disabling = nil, -- ran when disabling auto-save
		before_asserting_save = nil, -- ran before checking `condition`
		before_saving = function() require("autoformat").temp_lock(true) end,
		after_saving = function() require("autoformat").temp_lock(false) end,
	}
})
require("auto-save").on()

require("trouble").setup { }

require("bufferline").setup({
  options={
    mode="tabs",
    -- separator_style="slant",
    diagnostics = "nvim_lsp"
  }
})
require("lualine").setup({})
require("nvim-tree").setup({
  renderer = {
    add_trailing = true,
    group_empty = true,
    icons = {
      glyphs = {
        git = {
          ignored = ""
        }
      }
    }
  },
  git={
    ignore=false,
  },
  filters = {
    custom = {
       '\\.bloop$', 
       '\\.git$', 
       '\\.bsp$', 
       '\\.metals$', 
       'node_modules$'
    }
  },
  actions={
    change_dir={
      restrict_above_cwd=true
    },
    open_file={
      quit_on_open=false
    }
  }
})
