
local function create_list_config()
  return {
    name = "nvim_terminal_list",
    description = [[
List terminals opened in the editor. With this tool you can check if the terminal you started earlier is still running, ang get the details of it.
Use it if the user refers to siomething in a console or terminal. If you are unsure what terminal the user refers to, ask clarifications.
]],
    param = {
      type = "table",
      fields = {

      }
    },
    returns = {  
      {
        name = "terminals",
        description = "Structured string of ai_accessible terminals",
        type = "string",
      },
      {
        name = "error",
        description = "Error message if the operation was not successful",
        type = "string",
        optional = true,
      }
    },
    func = function(_, on_log, on_complete, _)
      -- Require toggleterm terminal
      local success, Terminal = pcall(require, "toggleterm.terminal")
      if not success then
        return false, nil, "Failed to require toggleterm.terminal"
      end

      -- Get all terminals
      local terminals = Terminal.get_all()

      -- Filter ai_accessible terminals
      local ai_accessible_terminals = terminals
      -- local ai_accessible_terminals = vim.tbl_filter(function(term)
      --   return term.ai_accessible
      -- end, terminals)
      

      -- Map and format the response
      ai_accessible_terminals = vim.tbl_map(function(term)
        return string.format(
          "Terminal Id: %s\nName: %s\nStarted by: %s\nCommand: %s\nDirectory: %s\n",
          term.id,
          term.display_name or "Unnamed",
          term.ai_accessible and "Agent" or "User",
          term.cmd,
          term.dir
        )
      end, ai_accessible_terminals)

      -- Return the structured string of ai_accessible terminals
      on_complete(table.concat(ai_accessible_terminals, "\n---\n"), nil)
    end,
  }
end

return create_list_config
