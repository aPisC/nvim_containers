local Const = require("sider.const")
local Sidebar = require("sider.sidebar")

local Sider_sidebars = nil

local Sider = {}

local function register_autocmds()
	if not Sider_sidebars then
		return
	end

	vim.api.nvim_create_autocmd({ "WinScrolled", "WinResized", "WinNew" }, {
		group = Const.augroup,
		callback = function(event)
			if not Sider_sidebars then
				return
			end

			local window_ids = vim.v.event.windows or {}
			if vim.tbl_contains(window_ids, Sider_sidebars.left.win) then
				Sider.update()
			end
		end,
	})

	vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
		group = Const.augroup,
		callback = function(ev)
			if not Sider_sidebars then
				return
			end

			local window = vim.fn.bufwinid(ev.buf)
			if vim.w[window]["sider-win"] then
				return
			end

			local sidebar = Sider_sidebars.left

			local function try_mount()
				local mounted = sidebar:try_mount_buf(ev.buf, window)

				if mounted then
					sidebar:open()
					sidebar:render()
				end
			end
			local result, error = pcall(try_mount)
		end,
	})
end

local function register_commands()
	vim.api.nvim_create_user_command("Sidebar", function()
		Sider.open()
	end, {})
end

function Sider.setup()
	if Sider_sidebars then
		Sider.clear()
	end

	Sider_sidebars = {
		left = Sidebar.new(),
	}

	Sider_sidebars.left:add_segment({
		title = "Neo Tree",
		open = "Neotree",
		condition = function(buf, win)
			if vim.bo[buf].filetype == "neo-tree" then
				return true
			end
		end,
	})

	Sider_sidebars.left:add_segment({
		title = "Overseer",
		open = "OverseerOpen",
		condition = function(buf, win)
			if vim.bo[buf].filetype == "OverseerList" then
				return true
			end
		end,
	})

	register_autocmds()
	register_commands()
end

function Sider.clear()
	if not Sider_sidebars then
		return
	end

	Sider_sidebars.left:unrender()
	Sider_sidebars = nil
end

function Sider.open()
	if not Sider_sidebars then
		return
	end

	Sider_sidebars.left:open()
end

function Sider.update()
	if not Sider_sidebars then
		return
	end

	Sider_sidebars.left:update()
end

function Sider.debug()
	print(vim.inspect({
		sidebars = Sider_sidebars,
	}))
end

return Sider
