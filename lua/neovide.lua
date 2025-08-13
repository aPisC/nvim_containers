local osu = require("utils.os")

if vim.g.neovide then
  vim.o.guifont = osu.cond({
    linux = "Fira Code:h10",
    windows = "FiraCode Nerd Font Propo:h10",
  })

  vim.g.neovide_opacity = 1
  vim.g.neovide_normal_opacity = 1

  vim.keymap.set({ "n", "v" }, "<C-ScrollWheelDown>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
  vim.keymap.set({ "n", "v" }, "<C-ScrollWheelUp>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
  vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
  vim.keymap.set({ "i" }, "<C-S-V>", "<C-o>:set paste<CR><C-R>+<C-o>:set nopaste<CR>")
  vim.keymap.set({ "c" }, "<C-S-V>", "<C-R>+")
  vim.keymap.set({ "t" }, "<C-S-V>", "<C-\\><C-n>pi")
  vim.keymap.set({ "n", "v" }, "<C-S-N>", function() vim.fn.jobstart({"neovide", "--no-multigrid"}, { detach = true, cwd=vim.env.HOME }) end)

  
  vim.g.neovide_cursor_animation_length = 0.13
  vim.g.neovide_cursor_vfx_mode = "pixiedust"

  vim.api.nvim_create_user_command('ToggleGobiMode', function()
    vim.g.neovide_cursor_animation_length = vim.g.neovide_cursor_animation_length == 0 and 0.13 or 0
    vim.g.neovide_cursor_vfx_mode = vim.g.neovide_cursor_vfx_mode == "" and "pixiedust" or ""
  end, {})
end
