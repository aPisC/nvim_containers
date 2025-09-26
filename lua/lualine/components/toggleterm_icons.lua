local M = require("lualine.component"):extend()
local lualine = require("lualine")
local term = require("toggleterm.terminal")
local toggleterm_config = require("toggleterm.config")

vim.g["lualine_toggleterm_icons_click_handler"] = function(id, _, btn)
  if id <= 0 then
	  local terminal = term.Terminal:new({ })
    terminal:open()
    lualine.refresh()
  else
    if btn == 'l' then
      term.get(id):toggle()
    elseif btn == 'r' then
      term.get(id):shutdown()
    end
  end
    

end

local default_options = {
  filter = function(terminal) return true end,
  icons = {
    terminal = "",
  },  
}

M.init = function(self, options)
  M.super.init(self, options)
  self.options = vim.tbl_deep_extend("force", {}, default_options, options)
end



M.update_status = function(self)
  local terminals = vim.tbl_filter(
    self.options.filter,
    term.get_all()
  )

  local text = table.concat(
    vim.tbl_map(
      function(terminal)
        local icon = terminal.__lualine_icon or self.options.icons.terminal
        local id_to_display = terminal.__lualine_hide_id and "" or tostring(terminal.id)
        return string.format( 
          "%%%s@v:lua.vim.g.lualine_toggleterm_icons_click_handler@%s%s%%T",
          terminal.id,
          icon,
          id_to_display
        )
      end,
      terminals
    ),
    " "
  )

  text = text .. string.format(
    " %%0@v:lua.vim.g.lualine_toggleterm_icons_click_handler@%s+%%T",
    self.options.icons.terminal
  )

  return text:gsub("^%s*(.-)%s*$", "%1")
end

return M

