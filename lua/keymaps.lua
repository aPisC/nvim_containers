-- Search and replace
vim.keymap.set({'v'}, '/', '\"zy/<C-r>z<CR>')
vim.keymap.set({'v'}, '<C-h>', '\"zy:%s/<C-r>z/')
vim.keymap.set({'i'}, 'jj', '<esc>')

-- vim.keymap.set({'n', 'i', 't'}, "<C-g>B", function() vim.cmd("OverseerRun") end)
vim.keymap.set({'n', 'i', 't'}, "<C-g>b", function() if vim.bo.filetype == "OverseerList" then vim.cmd("OverseerToggle") else vim.cmd("OverseerOpen") end end)
vim.keymap.set({'n', 'i', 't'}, "<C-g>t", function() if vim.v.count > 0 then vim.cmd("ToggleTerm " .. vim.v.count) else vim.cmd("ToggleTerm") end end)

vim.keymap.set({'n'}, '<A-left>', '<C-o>')
vim.keymap.set({'n'}, '<A-right>', '<C-i>')
vim.keymap.set({'n'}, '<C-t>', ':tabnew<CR>')


vim.keymap.set('n', '<C-b>', function() if vim.bo.filetype == "neo-tree" then vim.cmd"Neotree action=focus toggle" else vim.cmd"Neotree focus" end end )
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
-- vim.keymap.set({          't'}, '<esc>', '<C-\\><c-n>')
vim.keymap.set({'n'          }, '<C-d>', '<C-d>zz')
vim.keymap.set({'n'          }, '<C-u>', '<C-u>zz')
vim.keymap.set({'n'          }, '<C-o>', '<C-o>zz')
vim.keymap.set({'n'          }, '<C-i>', '<C-i>zz')
-- vim.keymap.set({'n'          }, '<C-n>', function() vim.cmd('enew') end)
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
vim.keymap.set({'n'          }, '<space>', 'ciw', {remap=true})

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
vim.keymap.set({'n'          }, '<C-Right>', 'e')
vim.keymap.set({     'i'     }, '<S-Up>', '<Left><C-o>vkl')
vim.keymap.set({     'i'     }, '<S-Down>', '<C-o>vhj<C-g>')
vim.keymap.set({     'i'     }, '<S-Left>', '<Left><C-o>vh<C-g>')
vim.keymap.set({     'i'     }, '<S-Right>', '<C-o>vl<C-g>')
vim.keymap.set({     'i'     }, '<C-S-Left>', '<Left><C-o>vb<C-g>')
vim.keymap.set({     'i'     }, '<C-S-Right>', '<C-o>ve<C-g>')
vim.keymap.set({     'i'     }, '<S-Home>', '<Left><C-o>v_<C-g>')
vim.keymap.set({     'i'     }, '<S-End>', '<C-o>v$<C-g>')
vim.keymap.set({     'i'     }, '<C-Left>', '<C-o>b')
vim.keymap.set({     'i'     }, '<C-Right>', '<C-o>e<Right>')
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

vim.keymap.set({'n',         },              '<esc>', ':noh <cr>', {remap = true})

-- Select mode wrap
vim.keymap.set('s', '"', '"<C-r>""')
vim.keymap.set('s', "'", "'<C-r>\"'")
vim.keymap.set('s', "`", "`<C-r>\"`")
vim.keymap.set('s', '(', '(<C-r>")')
vim.keymap.set('s', '[', '[<C-r>"]')
vim.keymap.set('s', '{', '{<C-r>"}')

-- Delete maps
vim.keymap.set('n', '<S-Delete>', 'dd')
vim.keymap.set('i', '<S-Delete>', '<C-o>dd')

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

-- Format
vim.keymap.set({'n', 'v', 'i'}, '<C-f>', function() vim.cmd("Format") end)
