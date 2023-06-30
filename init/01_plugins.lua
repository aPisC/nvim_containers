
vim.opt.shell="bash"
require("toggleterm").setup({
  start_in_insert = true,
  size = 5,
})

require("neogit").setup({
  disable_commit_confirmation = true,
  kind = "tab",
  integrations = {
    diffview = true
  },
  commit_popup = {
    kind = "tab"
  },
  popup = {
    kind = "tab"
  }
})

require('gitsigns').setup()

require('git-conflict').setup({})

require('barbecue').setup({
  theme='tokyonight',
  icons=false
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
  cs=true,
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

require("scope").setup({})
require("bufferline").setup({
  options={
    -- mode="tabs",
    -- separator_style="slant",
    diagnostics = "nvim_lsp",
    left_mouse_command = function (bufnr) 
      local winid = vim.fn.win_findbuf(bufnr)[1]
      if winid ~= nil then 
        vim.fn.win_gotoid(winid)
        return
      end
      vim.cmd("buf " .. bufnr)
    end,
    offsets = {
      {
          filetype = "dapui_breakpoints",
          text = "Debugger",
          highlight = "Directory",
          separator = true -- use a "true" to enable the default, or set your own character
      },
      {
          filetype = "dapui_scopes",
          text = "Debugger",
          highlight = "Directory",
          separator = true -- use a "true" to enable the default, or set your own character
      },
      {
          filetype = "NvimTree",
          text = "File Explorer",
          highlight = "Directory",
          separator = true -- use a "true" to enable the default, or set your own character
      },
    }
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
    },
  },
  update_focused_file = {
    enable = true,
  },
  git={
    ignore=true,
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
      quit_on_open=false,
      window_picker = {
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "prompt", "nofile", "terminal", "help" },
        },
      },
    }
  }
})

local builtin = require("statuscol.builtin")
local cfg = {
  setopt = true,   
  thousands = false,     -- or line number thousands separator string ("." / ",")
  relculright = true,   -- whether to right-align the cursor line number with 'relativenumber' set
  ft_ignore = nil,       -- lua table with filetypes for which 'statuscolumn' will be unset
  bt_ignore = nil,       -- lua table with 'buftype' values for which 'statuscolumn' will be unset
  segments = {
    {
      sign = { name = { "GitSigns" }, maxwidth = 1, colwidth=1, auto = false, wrap=true },
      click = "v:lua.ScSa"
    },
    {
      sign = { name = { "Diagnostic" }, fillchar=" ", maxwidth = 1, colwidth=1, auto = false, wrap=false },
      click = "v:lua.ScSa"
    },
    -- {
    --   sign = { name = { "LightBulb" }, fillchar=" ", maxwidth = 1, auto = false, wrap=false },
    --   click = "v:lua.ScSa"
    -- },
    {
      sign = { name = { ".*" }, maxwidth = 1, colwidth = 1, auto = false, wrap = false },
      click = "v:lua.ScSa"
    },
    {
      text = { builtin.lnumfunc, "" },
      condition = { true, builtin.not_empty },
      click = "v:lua.ScLa",
    },
    {
      sign = { name = { "Dap" }, fillchar=" ", maxwidth = 1, auto = true },
      click = "v:lua.ScSa"
    },
    {
      text = { '%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? "" : "") : " " }', " " },       -- table of strings or functions returning a string
      click = "v:lua.ScFa",  -- %@ click function label, applies to each text element
      hl = "FoldColumn",     -- %# highlight group label, applies to each text element
      condition = { true },  -- table of booleans or functions returning a boolean
      sign = {               -- table of fields that configure a sign segment
        maxwidth = 1,        -- maximum number of signs that will be displayed in this segment
        colwidth = 2,        -- number of display cells per sign in this segment
        auto = false,        -- when true, the segment will not be drawn if no signs matching the pattern are currently placed in the buffer.
        wrap = false,        -- when true, signs in this segment will also be drawn on the virtual or wrapped part of a line (when v:virtnum != 0).
        fillchar = " ",      -- character used to fill a segment with less signs than maxwidth
        fillcharhl = nil,    -- highlight group used for fillchar (SignColumn/CursorLineSign if omitted)
      }
    },
  },
  clickmod = "c",         -- modifier used for certain actions in the builtin clickhandlers:
                          -- "a" for Alt, "c" for Ctrl and "m" for Meta.
  clickhandlers = {       -- builtin click handlers
    Lnum                    = builtin.lnum_click,
    FoldClose               = builtin.foldclose_click,
    FoldOpen                = builtin.foldopen_click,
    FoldOther               = builtin.foldother_click,
    DapBreakpointRejected   = builtin.toggle_breakpoint,
    DapBreakpoint           = builtin.toggle_breakpoint,
    DapBreakpointCondition  = builtin.toggle_breakpoint,
    DiagnosticSignError     = builtin.diagnostic_click,
    DiagnosticSignHint      = builtin.diagnostic_click,
    DiagnosticSignInfo      = builtin.diagnostic_click,
    DiagnosticSignWarn      = builtin.diagnostic_click,
    GitSignsTopdelete       = builtin.gitsigns_click,
    GitSignsUntracked       = builtin.gitsigns_click,
    GitSignsAdd             = builtin.gitsigns_click,
    GitSignsChange          = builtin.gitsigns_click,
    GitSignsChangedelete    = builtin.gitsigns_click,
    GitSignsDelete          = builtin.gitsigns_click,
    gitsigns_extmark_signs_ = builtin.gitsigns_click,
    LightBulbSign           = function(args) vim.lsp.buf.code_action() end, 
  },
}
 require("statuscol").setup(cfg)


require('nvim-lightbulb').setup({
  autocmd = {enabled = true},
  ignore = {"null-ls"},
})
