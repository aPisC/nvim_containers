local osu = require("utils.os")
-- Vim options
--
--
--
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.updatetime = 500
vim.opt.autoread = true
vim.opt.termguicolors=true
vim.opt.clipboard="unnamedplus"
vim.opt.undofile = true

-- vim.opt.switchbuf="useopen"
-- vim.opt.verbose = 1
vim.opt.cmdheight = 0
vim.g.python3_host_prog = '/usr/bin/python3'

-- vim.opt.foldlevel = 20
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- vim.api.nvim_create_autocmd({ "BufEnter" }, { pattern = { "*" }, command = "normal zx", })
-- vim.opt.signcolumn = "auto:2-5"
-- vim.opt.equalalways = false

vim.opt.shell = osu.cond({
  linux = "/bin/bash",
  windows = "powershell"
})

if osu.get_os() == "windows" then
  vim.opt.shellcmdflag='-command'
  vim.opt.shellquote=''
  vim.opt.shellxquote=''
end

vim.noswapfile = true

vim.opt.splitkeep = "screen"
vim.opt.laststatus = 3


-- Settigns from sensible.vim
vim.opt.compatible = false
vim.opt.backspace = "indent,eol,start"
vim.opt.smarttab = true
vim.opt.nrformats = "hex,bin,unsigned"
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 100
vim.opt.incsearch = true
vim.opt.ruler = true

vim.opt.wildmenu = true
vim.opt.scrolloff = 2
vim.opt.sidescroll = 1
vim.opt.sidescrolloff = 5

vim.opt.listchars = "tab:>\\ ,trail:-,extends:>,precedes:<,nbsp:+"
vim.opt.autoread = true
vim.opt.history = 1000
vim.opt.tabpagemax = 50
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal"
vim.opt.viewoptions = "folds,cursor,curdir"
vim.opt.langremap = false


--   filetype plugin indent on
--   syntax enable


-- Fix highlighting in floating windows
vim.api.nvim_create_autocmd({ "BufEnter"}, {
  callback = function(ev)
    vim.wo.winhighlight = vim.wo.winhighlight
  end,
})

