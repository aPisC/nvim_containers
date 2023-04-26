-- Vim options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2 
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.updatetime = 500
vim.opt.autoread = true
vim.opt.termguicolors=true
-- vim.opt.verbose = 1
vim.opt.cmdheight = 2
vim.g.python3_host_prog = '/usr/bin/python3'

vim.opt.foldlevel = 20
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
