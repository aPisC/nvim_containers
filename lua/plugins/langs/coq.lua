return {
  {
    'whonore/Coqtail',
    config = function() 
      vim.api.nvim_create_autocmd({"FileType"}, { pattern = {"coq"}, callback=function()
        vim.keymap.set({'n', 'i'}, '<C-Down>', function() vim.cmd"CoqNext" end, {buffer=true})
        vim.keymap.set({'n', 'i'}, '<C-Up>', function() vim.cmd"CoqUndo" end, {buffer=true})
      end})
    end,
  },
}
