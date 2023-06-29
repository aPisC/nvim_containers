-- Navigation keymaps
vim.keymap.set({'n', 'i', 't'}, "<C-p>", function() vim.cmd("Telescope git_files") end)
vim.keymap.set({'n', 'i', 't'}, "<C-S-p>", function() vim.cmd("Telescope commands") end)
-- vim.keymap.set({'n', 'i', 't'}, "<C-p><C-p>", function() vim.cmd("Telescope commands") end)

vim.keymap.set({'n', 'i'     }, "<C-g>h", function() require("harpoon.mark").toggle_file() end)
vim.keymap.set({'n', 'i', 't'}, "<C-g>j", function() require("harpoon.ui").nav_next() end)
vim.keymap.set({'n', 'i', 't'}, "<C-g>k", function() require("harpoon.ui").nav_prev() end)
vim.keymap.set({'n', 'i', 't'}, '<c-g>f', function() vim.cmd("Telescope find_files") end)
vim.keymap.set({'n', 'i', 't'}, '<c-g>a', function() vim.cmd('Telescope buffers') end)
vim.keymap.set({'n', 'i', 't'}, '<c-g>e', function() vim.cmd('TroubleToggle') end)
vim.keymap.set({'n', 'i', 't'}, '<c-g>E', vim.diagnostic.goto_next)
vim.keymap.set({'n', 'i', 't'}, "<C-g>b", function() vim.cmd("Telescope toggletasks spawn") end)
vim.keymap.set({'n', 'i', 't'}, "<C-g>B", function() vim.cmd("Telescope toggletasks select") end)
vim.keymap.set({'n', 'i', 't'}, "<C-g>t", function() if vim.v.count > 0 then vim.cmd("ToggleTerm " .. vim.v.count) else vim.cmd("ToggleTerm") end end)
vim.keymap.set({'n', 'i', 't'}, '<c-g><c-g>', function() require("neogit").open()  end)
vim.keymap.set({'n'          }, '<c-g>u', function() vim.cmd('UndotreeToggle') end)

vim.keymap.set({'n', 'i', 't'}, '<c-b>', function() vim.cmd('NvimTreeToggle') end)
-- vim.keymap.set({'n', 'i', 't'}, '<C-b><C-b>', function() vim.cmd('NvimTreeFindFile') end)

vim.keymap.set({'n'}, '<A-left>', '<C-o>')
vim.keymap.set({'n'}, '<A-right>', '<C-i>')

vim.keymap.set({'n'}, '<C-w><C-k>', '<C-w>k<C-w>_')
vim.keymap.set({'n'}, '<C-w><C-j>', '<C-w>j<C-w>_')
vim.keymap.set({'n'}, '<C-t>', ':tabnew<CR>')


-- vim.keymap.set({'n'}, 'gt', function() 
--   if vim.v.count > 0 then
--     vim.cmd(vim.v.count .. 'bn')
--   else
--     vim.cmd("bn")
--   end
-- end)
-- vim.keymap.set({'n'}, 'gT', function() 
--   if vim.v.count > 0 then
--     vim.cmd(vim.v.count .. 'bp')
--   else
--     vim.cmd("bp")
--   end
-- end)


-- LSP and Debugger keymaps
vim.keymap.set('n', '<F12>', function() vim.cmd("Telescope lsp_definitions") end)
vim.keymap.set('n', '<F24>', function() vim.cmd("Telescope lsp_references") end) -- <S-F12>
vim.keymap.set('n', 'gd', function() vim.cmd("Telescope lsp_definitions") end)
vim.keymap.set('n', 'gr', function() vim.cmd("Telescope lsp_references") end)
vim.keymap.set('n', 'gi', function() vim.cmd("Telescope lsp_implementations") end)
-- vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<F2>', vim.lsp.buf.rename)
vim.keymap.set({'n', 'i'}, '<M-CR>', vim.lsp.buf.code_action)

vim.keymap.set({'n', 'i'}, "<F5>", function() require("dap").continue() end)
vim.keymap.set({'n', 'i'}, "<F17>", function() require("dap").terminate() end) -- <S-F5>
vim.keymap.set({'n', 'i'}, "<F9>", function() require("dap").toggle_breakpoint() end)
vim.keymap.set({'n', 'i'}, "<F21>", function() 
  local condition = vim.fn.input("Condition: ")
  if condition ~= "" then
    require("dap").set_breakpoint(condition)
    return
  end

  local logMessage = vim.fn.input("Log message: ")
  if logMessage ~= "" then 
    require("dap").set_breakpoint(nil, nil, logMessage)
    return
  end

  require("dap").set_breakpoint()
end)
vim.keymap.set({'n', 'i'}, "<F10>", function() require("dap").step_over() end)
vim.keymap.set({'n', 'i'}, "<F11>", function() require("dap").step_into() end)
vim.keymap.set({'n', 'i'}, "<F23>", function() require("dap").step_out() end) -- <S-F11>
vim.keymap.set({'n'     }, "<space>K", vim.diagnostic.open_float)
vim.keymap.set('n', '<C-k>', function(args) vim.lsp.codelens.run() end)
vim.keymap.set('n', 'K', function(args)
  if require("dap").session() then
    require("dap.ui.widgets").hover()
  -- elseif #vim.diagnostic.get(0, {lnum = vim.api.nvim_win_get_cursor(0)[1] - 1} ) > 0 then
  --   vim.diagnostic.open_float()
  else
    vim.lsp.buf.hover(args)
  end
end)


-- Editing keymaps
vim.keymap.set({'n', 'i'     }, '<C-s>', function() 
  local tries = 0
  while tries < 10 and vim.api.nvim_get_mode().mode == "i" do
    vim.api.nvim_input("<esc>")
    tries = tries + 1
  end  
  vim.api.nvim_input(":w<cr>")
end)
-- vim.keymap.set({'n', 'i', 't', 'v'}, '<C-q>', function() vim.cmd('q') end)
vim.keymap.set({'n', 'i', 't', 'v'}, '<C-q>', function()
  if #vim.api.nvim_list_wins() > 1 or vim.bo.buftype == "prompt" then
    vim.cmd("q")
  else
    vim.cmd('bd %') 
  end
end)
vim.keymap.set({          't'}, '<c-w>', '<C-\\><c-n>')
vim.keymap.set({'n'          }, '<C-d>', '<C-d>zz')
vim.keymap.set({'n'          }, '<C-u>', '<C-u>zz')
vim.keymap.set({'n'          }, '<C-o>', '<C-o>zz')
vim.keymap.set({'n'          }, '<C-i>', '<C-i>zz')
vim.keymap.set({'n'          }, '<C-n>', function() vim.cmd('enew') end)
vim.keymap.set({'n'          }, 'cp', 'viwpgvy')
vim.keymap.set({'n'          }, 'cP', 'viWpgvy')
vim.keymap.set({'v'          }, 'p', 'pgvy')
vim.keymap.set({'v'          }, '>', '>gv')
vim.keymap.set({'v'          }, '<', '<gv')
vim.keymap.set({     'i', 'v'}, '<C-z>', function() 
  vim.cmd('undo')
  if vim.api.nvim_get_mode().mode ~= "i" then
    vim.api.nvim_input("<esc>i") 
  end  
end)
vim.keymap.set({     'i', 'v'}, '<C-y>', function() vim.cmd('redo') end)

-- Shift selecting
vim.keymap.set({'n'          }, '<S-Up>', 'vk')
vim.keymap.set({'n'          }, '<S-Down>', 'vj')
vim.keymap.set({'n'          }, '<S-Left>', 'vh')
vim.keymap.set({'n'          }, '<S-Right>', 'vl')
vim.keymap.set({'n'          }, '<C-S-Left>', 'vb')
vim.keymap.set({'n'          }, '<C-S-Right>', 've')
vim.keymap.set({'n'          }, '<S-Home>', 'v_')
vim.keymap.set({'n'          }, '<S-End>', 'v$')
vim.keymap.set({'n'          }, '<S-End>', 'v$')
vim.keymap.set({'n'          }, '<C-Left>', 'b')
vim.keymap.set({     'i'     }, '<S-Right>', 'e')
vim.keymap.set({     'i'     }, '<S-Down>', '<C-o>vhj<C-g>')
vim.keymap.set({     'i'     }, '<S-Left>', '<Left><C-o>vh<C-g>')
vim.keymap.set({     'i'     }, '<S-Right>', '<C-o>vl<C-g>')
vim.keymap.set({     'i'     }, '<C-S-Left>', '<Left><C-o>vb<C-g>')
vim.keymap.set({     'i'     }, '<C-S-Right>', '<C-o>ve<C-g>')
vim.keymap.set({     'i'     }, '<S-Home>', '<Left><C-o>v_<C-g>')
vim.keymap.set({     'i'     }, '<S-End>', '<C-o>v$<C-g>')
vim.keymap.set({     'i'     }, '<C-Left>', '<C-o>b')
vim.keymap.set({     'i'     }, '<C-Right>', '<C-o>e<Left>')
vim.keymap.set({'v'          }, '<S-Up>', 'k')
vim.keymap.set({'v'          }, '<S-Down>', 'j')
vim.keymap.set({'v'          }, '<S-Left>', 'h')
vim.keymap.set({'v'          }, '<S-Right>', 'l')
vim.keymap.set({'v'          }, '<C-S-Left>', 'b')
vim.keymap.set({'v'          }, '<C-S-Right>', 'e')
vim.keymap.set({'v'          }, '<C-Left>', 'b')
vim.keymap.set({'v'          }, '<C-Right>', 'e')

vim.keymap.set({'n', 'i'     }, '<A-down>', function() vim.cmd("move +1") end)
vim.keymap.set({'n', 'i'     }, '<A-j>', function() vim.cmd("move +1") end)
vim.keymap.set({'n', 'i'     }, '<A-up>', function() vim.cmd("move -2") end)
vim.keymap.set({'n', 'i'     }, '<A-k>', function() vim.cmd("move -2") end)
vim.keymap.set({'v'          }, '<A-down>', ":m '>+1<CR>gv=gv")
vim.keymap.set({'v'          }, '<A-j>',  ":m '>+1<CR>gv=gv")
vim.keymap.set({'v'          }, '<A-up>', ":m '<-2<CR>gv=gv")
vim.keymap.set({'v'          }, '<A-k>',  ":m '<-2<CR>gv=gv")

vim.keymap.set('',              '<esc>', ':noh <cr>', {remap = true})

-- Select mode wrap
vim.keymap.set('s', '"', '"<C-r>""')
vim.keymap.set('s', "'", "'<C-r>\"'")
vim.keymap.set('s', "`", "`<C-r>\"`")
vim.keymap.set('s', '(', '(<C-r>")')
vim.keymap.set('s', '[', '[<C-r>"]')
vim.keymap.set('s', '{', '{<C-r>"}')

-- HU keymaps
vim.keymap.set({'n',      'v'}, 'ő', '[', {remap=true})
vim.keymap.set({'n',      'v'}, 'Ő', '{', {remap=true})
vim.keymap.set({'n',      'v'}, 'ú', ']', {remap=true})
vim.keymap.set({'n',      'v'}, 'Ú', '}', {remap=true})
vim.keymap.set({'n',      'v'}, 'ó', '=', {remap=true})
vim.keymap.set({'n',      'v'}, 'í', '`', {remap=true})
vim.keymap.set({'n',      'v'}, 'Í', '~', {remap=true})
vim.keymap.set({'n',      'v'}, 'é', ";", {remap=true})
vim.keymap.set({'n',      'v'}, 'É', ':', {remap=true})
vim.keymap.set({'n',      'v'}, 'á', "'", {remap=true})
vim.keymap.set({'n',      'v'}, 'Á', '"', {remap=true})
vim.keymap.set({'n',      'v'}, 'ű', "\\", {remap=true})
vim.keymap.set({'n',      'v'}, 'Ű', '|', {remap=true})

