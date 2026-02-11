local osu = require("utils.os")

local update_neovide_title = function(title)
	return coroutine.wrap(function()
		local nvim_pid = vim.fn.getpid()
		local co = coroutine.running()
		-- get neovide pid
		vim.system({ "ps", "-o", "ppid=", "-p", nvim_pid }, {
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

	vim.g.neovide_cursor_animation_length = 0.13
	vim.g.neovide_cursor_vfx_mode = "pixiedust"

	vim.api.nvim_create_autocmd("DirChanged", {
		pattern = "*",
		callback = function()
			if require("utils.os").get_os() ~= "linux" then
				return
			end
			local cwd = vim.fn.getcwd()
			local foldername = vim.fn.fnamemodify(cwd, ":t")
			update_neovide_title("Neovide (" .. foldername .. ")")
		end,
	})
end
