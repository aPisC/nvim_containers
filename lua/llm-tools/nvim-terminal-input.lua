local function create_feed_keys_tool()
  return {
    name = "nvim_terminal_input",
    description = [[
Use this tool to send some input to a terminal. With this tool you can provide inputs to command line tools if needed.
This tool will type in the text you provide, if you need to press an enter, sendf a new line `\n` character.
The arrow keys can be sent with the <UP>, <DOWN>, <LEFT>, <RIGHT> sequences.
This will not return the result of the action, if you need top see what the input resulted, use the nvim_terminal_read tool to read the terminal output.
To see what terminals are available, use the nvim_terminal_list tool
]],
    param = {
      type = "table",
      fields = {
        {
          name = "terminal_id",
          description = "ID of the terminal to send keys to",
          type = "number",
        },
        {
          name = "input",
          description = "Input to send to the terminal",
          type = "string",
        }
      },
    },
    returns = {
      {
        name = "success",
        description = "Boolean indicating if the keys were successfully sent",
        type = "boolean",
      },
      {
        name = "error",
        description = "Error message if the operation was not successful",
        type = "string",
        optional = true,
      }
    },
    func = function(opts, on_log, on_complete, session_ctx)
      -- require modules
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

      local keys_to_send = opts.input
      keys_to_send = keys_to_send:gsub("<UP>", "\x1b[A")
      keys_to_send = keys_to_send:gsub("<DOWN>", "\x1b[B")
      keys_to_send = keys_to_send:gsub("<RIGHT>", "\x1b[C")
      keys_to_send = keys_to_send:gsub("<LEFT>", "\x1b[D")

      -- Request confirmation before sending keys
      Helpers.confirm(
        string.format("Are you sure you want to send the following input to terminal %s?\n%s", opts.terminal_id, vim.inspect(opts.input)),
        function(ok, reason)
          if ok then
            vim.api.nvim_chan_send(term.job_id, keys_to_send)
            on_complete(true, nil)
          else
            on_complete(false, "Action rejected by user: " .. (reason and reason or "unknown"))
          end
        end,
        { focus = true },
        session_ctx
      )
    end,
  }
end

return create_feed_keys_tool

