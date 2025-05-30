local function create_terminal_read_tool()
  return {
    name = "nvim_terminal_read",
    description = [[
Reads the content of a terminal buffer. You can specify the number of lines to read from the end of the buffer. If not specified, the whole buffer will be read.
Use this tool if some dev server was started in a nvim terminal and the user asks details about the compilation or errors that can be producd by build servers.
To get the terminal id, you can use the nvim_terminal_list tool and list the opened terminals
]],
    param = {
      type = "table",
      fields = {
        {
          name = "terminal_id",
          description = "ID of the terminal to read from",
          type = "number",
        },
        {
          name = "num_lines",
          description = "Number of lines to read from the end of the buffer. If not specified, the whole buffer will be read.",
          type = "number",
          optional = true,
        }
      },
    },
    returns = {
      {
        name = "content",
        description = "Content of the terminal buffer",
        type = "string",
      },
      {
        name = "error",
        description = "Error message if the terminal could not be read",
        type = "string",
        optional = true,
      }
    },
    func = function(opts, on_log, on_complete, session_ctx)
      -- Require modules
      local Helpers = require("avante.llm_tools.helpers")

      -- Require toggleterm terminal
      local success, Terminal = pcall(require, "toggleterm.terminal")
      if not success then
        return false, "Failed to require toggleterm.terminal"
      end

      -- Find the terminal by ID
      local term = Terminal.get(opts.terminal_id)
      if not term then
        return false, "Terminal not found with ID: " .. opts.terminal_id
      end

      -- Function to read terminal content
      local function read_terminal_content()
        local bufnr = term.bufnr
        local lines
        if opts.num_lines then
          local total_lines = vim.api.nvim_buf_line_count(bufnr)
          local start_line = math.max(0, total_lines - opts.num_lines)
          lines = vim.api.nvim_buf_get_lines(bufnr, start_line, total_lines, false)
        else
          lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        end

        local content = table.concat(lines, "\n")
        on_complete(content, nil)
      end

      -- Verification flow
      if term.ai_accessible then
        read_terminal_content()
      else
        Helpers.confirm(
          string.format("Terminal %s is not started by the AI assistant. Do you want to proceed with reading its content?", opts.terminal_id),
          function(ok, reason)
            if ok then
              term.__lualine_icon = "󰧑"
              term.ai_accessible = true
              read_terminal_content()
            else
              on_complete(nil, "Action rejected by user: " .. (reason and reason or "unknown"))
            end
          end,
          { focus = true },
          session_ctx
        )
      end
    end,
  }
end

return create_terminal_read_tool

