local Const = require("sider.const")
local Sidebar = require("sider.sidebar")

local Sider_sidebars = nil

local sidebar_keys = {"left", "right"}
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
      for _, sidebar_key in ipairs(sidebar_keys) do
        local sidebar = Sider_sidebars[sidebar_key]
        if vim.tbl_contains(window_ids, sidebar.win) then
          sidebar:update()
        end
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


      for _, sidebar_key in ipairs(sidebar_keys) do
        local sidebar = Sider_sidebars[sidebar_key]
        local mounted = sidebar:try_mount_buf(ev.buf, window)
        if mounted then
          sidebar:open()
          sidebar:render()
          return
        end
      end
		end,
	})
end

local function register_commands()
	vim.api.nvim_create_user_command("Sidebar", function(args)
		Sider.open(args.args)
	end, {nargs="?"})
end

function Sider.setup(opts)
	opts = opts or {}

	if Sider_sidebars then
		Sider.clear()
	end

	Sider_sidebars = {
		left = Sidebar.new({
      position = "left",
      close_if_empty = vim.tbl_get(opts, "left", "close_if_empty")
    }),
		right = Sidebar.new({
      position = "right",
      close_if_empty = vim.tbl_get(opts, "right", "close_if_empty")
    }),
	}

	for _, segment in ipairs(vim.tbl_get(opts, "left", "segments") or {}) do
		Sider_sidebars.left:add_segment(segment)
	end

  for _, segment in ipairs(vim.tbl_get(opts, "right", "segments") or {}) do
    Sider_sidebars.right:add_segment(segment)
  end

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

function Sider.open(direction)
	if not Sider_sidebars then
		return
	end
  
  if direction == "right" then
    Sider_sidebars.right:open()
  else
    Sider_sidebars.left:open()
  end
end

function Sider.update()
	if not Sider_sidebars then
		return
	end

  for _, sidebar_key in ipairs(sidebar_keys) do
    local sidebar = Sider_sidebars[sidebar_key]
    sidebar:update()
  end
end

function Sider.debug()
	print(vim.inspect({
		sidebars = Sider_sidebars,
	}))
end

return Sider
