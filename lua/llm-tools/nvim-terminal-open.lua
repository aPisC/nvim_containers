local default_options = { }

local banned_commands = {
  "alias",
  "curl",
  "curlie",
  "wget",
  "axel",
  "aria2c",
  "nc",
  "telnet",
  "lynx",
  "w3m",
  "links",
  "httpie",
  "xh",
  "http-prompt",
  "chrome",
  "firefox",
  "safari",
}

local function create_config(opts)
  opts = vim.tbl_deep_extend("force", {}, default_options, opts or {})

  return {
      name = "nvim_teminal_open", 
      description =  [[Executes a given bash command in a persistent shell session with optional timeout, ensuring proper handling and security measures. Do not use bash command to read or modify files, or you will be fired.
This terminal will be seen and managed by the user. Use this for commands that could run infinitely or requires inputs.  start this terminal in a deattached state, if you are not required to  wait for the command to finish (for example starting a service for the user).
You will be able to access this terminal in the future, with the nvim_terminal_list and nvim_teminal_read tools.
]],
      param = {  
        type = "table",
        fields = {
          {
            name = "rel_path",
            description = "Relative path to the project directory, as cwd. If you need to run a command in another directory, configure this argument properly instead of using `cd`",
            type = "string",
          },
          {
            name = "command",
            description = "Command to run",
            type = "string",
          },
          {
            name = "deattached",
            description = "If true, the command will be run in a deattached state, the output will not be provided to you, and you won't wait to the execution to finish",
            type = "boolean",
          },
          {
            name = "display_name",
            description = "Name of the terminal session. Use a short but explanatory name.",
            type = "string",
            optional = true,
          }
        },
      },
      returns = {  -- Expected return values
        {
          name = "stdout",
          description = "Output of the command",
          type = "string",
        },
        {
          name = "error",
          description = "Error message if the command was not run successfully",
          type = "string",
          optional = true,
        }
      },
      func = function(opts, on_log, on_complete, session_ctx)
        -- Require modules
        local Path = require("plenary.path")
        local Utils = require("avante.utils")
        local Helpers = require("avante.llm_tools.helpers")
        local Base = require("avante.llm_tools.base")
        local Config = require("avante.config")
        local Providers = require("avante.providers")


        -- Check args
        local abs_path = Helpers.get_abs_path(opts.rel_path)
        if not Helpers.has_permission_to_access(abs_path) then return false, "No permission to access path: " .. abs_path end
        if not Path:new(abs_path):exists() then return false, "Path not found: " .. abs_path end
        if on_log then on_log("command: " .. opts.command) end

        if not on_complete then return false, nil, "on_complete not provided" end
        
        -- Require toggleterm terminal
        local success, Terminal = pcall(require, "toggleterm.terminal")
        if not success then
          return false, nil, "Failed to require toggleterm.terminal"
        end
        Terminal = Terminal.Terminal


        Helpers.confirm(
          "Are you sure you want to open the command in a terminal window: `" .. opts.command .. "` in the directory: " .. abs_path,
          function(ok, reason)
            if not ok then
              on_complete(false, "User declined, reason: " .. (reason and reason or "unknown"))
              return
            end

            local stdout = ""
            local outcome_handled = false

            local term = Terminal:new({
              close_on_exit = false,
              cmd = opts.command,
              dir = abs_path,
              display_name = opts.display_name,
              on_stdout = function(_, _, data)
                if not outcome_handled then
                  stdout = stdout .. table.concat(data, "\n") .. "\n"
                end
              end,
              on_stderr = function(_, _, data)
                if not outcome_handled then
                  stdout = stdout .. table.concat(data, "\n") .. "\n"
                end
              end,
              on_exit = function(term, _, exit_code, _)
                if not outcome_handled then
                  outcome_handled = true
                  if exit_code ~= 0 then
                    if stdout ~= "" then
                      on_complete(stdout, "Error: " .. stdout .. "; Error code: " .. exit_code)
                    else
                      on_complete(stdout, "Command failed with exit code: " .. exit_code)
                    end
                  else
                    on_complete(stdout, nil)
                  end
                end
              end,
            })
            term.ai_accessible = true
            term:open()

            if opts.deattached then 
              vim.defer_fn(function()
                if not outcome_handled then
                  outcome_handled = true
                  on_complete(stdout, nil)
                end
              end, 5000)
            end
          end,
          { focus = true },
          session_ctx
        )
      end,
    }
end

return create_config


