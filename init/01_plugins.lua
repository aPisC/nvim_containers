
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
    kind = "replace"
  }
})



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
      quit_on_open=false
    }
  }
})

local builtin = require("statuscol.builtin")
local cfg = {
  setopt = true,   
  thousands = false,     -- or line number thousands separator string ("." / ",")
  relculright = false,   -- whether to right-align the cursor line number with 'relativenumber' set
  ft_ignore = nil,       -- lua table with filetypes for which 'statuscolumn' will be unset
  bt_ignore = nil,       -- lua table with 'buftype' values for which 'statuscolumn' will be unset
  segments = {
    { text = { "%s" }, click = "v:lua.ScSa" },
    {
      text = { builtin.lnumfunc, "" },
      condition = { true, builtin.not_empty },
      click = "v:lua.ScLa",
    },
    {
      text = { '%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? "" : "") : " " }', " " },       -- table of strings or functions returning a string
      click = "v:lua.ScFa",  -- %@ click function label, applies to each text element
      hl = "FoldColumn",     -- %# highlight group label, applies to each text element
      condition = { true },  -- table of booleans or functions returning a boolean
      sign = {               -- table of fields that configure a sign segment
        -- at least one of "name", "text", and "namespace" is required
        -- legacy signs are matched against the defined sign name e.g. "DiagnosticSignError"
        -- extmark signs can be matched agains either the namespace or the sign text itself
        -- name = { ".*" },     -- table of lua patterns to match the sign name against
        -- text = { ".*" },     -- table of lua patterns to match the extmark sign text against
        -- namespace = { ".*" },-- table of lua patterns to match the extmark sign namespace against
        -- below values list the default when omitted:
        maxwidth = 1,        -- maximum number of signs that will be displayed in this segment
        colwidth = 2,        -- number of display cells per sign in this segment
        auto = false,        -- when true, the segment will not be drawn if no signs matching
        -- the pattern are currently placed in the buffer.
        wrap = false,        -- when true, signs in this segment will also be drawn on the
        -- virtual or wrapped part of a line (when v:virtnum != 0).
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
  },
}
 require("statuscol").setup(cfg)
