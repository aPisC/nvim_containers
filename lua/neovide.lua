local osu = require("utils.os")

local update_neovide_title = function(title)
	return coroutine.wrap(function()
		local nvim_pid = vim.fn.getpid()
		local co = coroutine.running()
		-- get neovide pid
		vim.system({ "ps", "-o", "ppid=", '-p', nvim_pid }, {
			timeout = 1000,
			-- stderr = function(err, data) end,
			-- stdout = function(err, data) end,
		}, function(out)
			vim.schedule(function()
				local lines = vim.split(out.stdout:gsub("%s+$", ""), "\n")
				coroutine.resume(co, vim.trim(lines[1]))
			end)
		end)
    local neovide_pid = coroutine.yield()

    -- get window handler
		vim.system({ "wmctrl", "-l", "-p", nvim_pid }, {
			timeout = 1000,
			-- stderr = function(err, data) end,
			-- stdout = function(err, data) end,
		}, function(out)
			vim.schedule(function()
				local lines = vim.split(out.stdout:gsub("%s+$", ""), "\n")
				local win_handle = nil
				for _, line in ipairs(lines) do
					local parts = vim.split(line, "%s+")
					if parts[3] == tostring(neovide_pid) then
						win_handle = parts[1]
						break
					end
				end
				coroutine.resume(co, win_handle)
			end)
		end)
    local win_handle = coroutine.yield()


    -- Update title
    vim.system({ "wmctrl", "-i", "-r", win_handle, "-N", title }, {
        timeout = 1000,
    }, function(out) end)
	end)(title)
end

if vim.g.neovide then
  vim.o.guifont = osu.cond({
    linux = "Fira Code:h10",
    windows = "FiraCode Nerd Font Propo:h10",
  })

  vim.g.neovide_opacity = 1
  vim.g.neovide_normal_opacity = 1

  vim.keymap.set({ "n", "v" }, "<C-ScrollWheelDown>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
  vim.keymap.set({ "n", "v" }, "<C-ScrollWheelUp>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
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

  vim.api.nvim_create_user_command('NeovideToggleOpacity', function(opts)
     local opacity

     if opts.args and opts.args ~= "" then
       opacity = tonumber(opts.args)
       if not opacity or opacity < 0 or opacity > 1 then
         vim.notify("Invalid opacity value. Must be between 0 and 1", vim.log.levels.ERROR)
         return
       end
     else
       opacity = vim.g.neovide_normal_opacity == 1 and 0.8 or 1
     end

     vim.g.neovide_normal_opacity = opacity
  end, { nargs = "?" })

  vim.api.nvim_create_autocmd("DirChanged", {
    pattern = "*",
    callback = function()
      if require("utils.os").get_os() ~= "linux" then return end
      local cwd = vim.fn.getcwd()
      local foldername = vim.fn.fnamemodify(cwd, ":t")
      update_neovide_title("Neovide (" .. foldername .. ")")
    end,
  })
end
