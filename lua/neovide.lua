if vim.g.neovide then
  vim.o.guifont = "Fira Code:h10"

  vim.g.neovide_opacity = 0.8
  vim.g.neovide_normal_opacity = 1

  vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
  vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
  vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
  vim.keymap.set({ "i" }, "<C-S-V>", "<C-o>:set paste<CR><C-R>+<C-o>:set nopaste<CR>")
  vim.keymap.set({ "t", "c" }, "<C-S-V>", "<C-R>+")
end
