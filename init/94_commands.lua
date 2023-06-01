local command = vim.api.nvim_create_user_command

-- Harpoon commands
command('Harpoon', function() require("harpoon.ui").toggle_quick_menu() end, {})
command('HarpoonClear', function() require("harpoon.mark").clear_all() end, {})


-- LSP
-- command('LspFormat', function() vim.lsp.buf.format { async = false } end, {})
-- vim.api.nvim_create_autocmd({"CursorHold"}, { pattern = {"*"}, callback=vim.lsp.buf.hover })
--
-- REST
command('RestRun', function() require("rest-nvim").run() end, {})
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, { pattern = {"*.http"}, callback=function()
  vim.keymap.set('n', '\\<CR>', function() require("rest-nvim").run() end, {buffer=vim.api.nvim_buf_get_number(0)})
end})

-- Editor commands
command('Ey', function() vim.cmd("tabe " .. vim.fn.getreg('"')) end, {})
command('Metals', require("telescope").extensions.metals.commands, {})
command("ASToggle", function() require("auto-save").toggle() end, {})
command("DapUi", function() 
  vim.cmd(":NvimTreeClose")
  local dapui = require("dapui")
  dapui.toggle()
end, {})

-- vim.cmd('autocmd CursorHold  * lua vim.lsp.buf.document_highlight()')
-- vim.cmd('autocmd CursorHoldI * lua vim.lsp.buf.document_highlight()')
-- vim.cmd('autocmd CursorMoved * lua vim.lsp.buf.clear_references()')
--

-- Test commands
command('TestStop', function() require("neotest").run.stop() end, {})
command('TestFile', function() require("neotest").run.run(vim.fn.expand("%")) end, {})
command('TestNearest', function() require("neotest").run.run() end, {})
command('TestLast', function() require("neotest").run.run() end, {})
command('TestSummary', function() require(neotest).summary.toggle() end, {})


-- Other commands
command('Term', function() vim.cmd("ToggleTerm") end, {})
command('Git', function() require"neogit".open() end, {nargs=0, force= true})
