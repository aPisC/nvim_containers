local Const = require("sider.const")
local Sidebar = require("sider.sidebar")

local Sider_sidebars = nil

local Sider = setmetatable({}, {
  __index = function(_, key)
    return ({
      sidebars = Sider_sidebars,
    })[key]
  end,
})

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
      for _, sidebar in pairs(Sider_sidebars) do
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
			if vim.w[window]["sider-win"] then return end
      if vim.b[ev.buf]["sider-rendering"] then return end


      for sidebar_key, sidebar in pairs(Sider_sidebars) do
        local mounted = sidebar:try_mount_buf(ev.buf, window)
        if mounted then
          sidebar:open()
          vim.defer_fn(Sider.update, 0)
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

	Sider_sidebars = {}

  for sb_key, sb_config in pairs(opts) do
    Sider_sidebars[sb_key] = Sidebar.new({
      position = sb_config.position or sb_key,
      close_if_empty = vim.tbl_get(sb_config, "close_if_empty", true),
      single = sb_config.single,
    })
    for _, segment in ipairs(vim.tbl_get(sb_config, "segments") or {}) do
      Sider_sidebars[sb_key]:add_segment(segment)
    end
  end

	register_autocmds()
	register_commands()
end

function Sider.clear()
	if not Sider_sidebars then
		return
	end

  for _, sidebar in pairs(Sider_sidebars) do
    sidebar:unrender()
  end
end

function Sider.open(direction)
  if Sider_sidebars and Sider_sidebars[direction] then
    Sider_sidebars[direction]:open()
  end
end

function Sider.update()
	if not Sider_sidebars then
		return
	end

  for _, sidebar in pairs(Sider_sidebars) do
    sidebar:update()
  end
end

function Sider.debug()
	print(vim.inspect({
		sidebars = Sider_sidebars,
	}))
end

return Sider
