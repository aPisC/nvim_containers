local default_options = {

}

local function create_config(opts)
  opts = vim.tbl_deep_extend("force", {}, default_options, opts or {})

  return {
      name = "nvim_file_open", 
      description = [[
This tool can open a file in the Nvim UI. 
Use this tool if the user requests you to show them something or you want to show something in the file for the user.
You can combine this tool with add_file_to_context to make both the user, and the agent able to read the file you two are talking about.
]],  -- Description shown to AI
      param = {  
        type = "table",
        fields = {
          {
            name = "file_path",
            description = "Path of the file",
            type = "string",
            optional = false,
          },
        },
      },
      returns = {  -- Expected return values
        {
          name = "success",
          description = "Indicates if the file opening was succesful",
          type = "boolean",
        },
        {
          name = "error",
          description = "Error message if the open was not successful",
          type = "string",
          optional = true,
        },
      },
      func = function(params, on_log, on_complete)
        local file_path = params.file_path

        -- Check if the file exists
        local file = io.open(file_path, "r")
        if not file then
          on_complete(false, "File does not exist: " .. file_path )
          return
        end
        file:close()

        -- Function to open file in a specific window
        local function open_file_in_window(win_id)
          vim.api.nvim_set_current_win(win_id)
          vim.cmd('edit ' .. file_path)
        end

        -- Iterate through windows to find an empty one first
        local windows = vim.api.nvim_list_wins()
        local empty_window = nil
        local editable_window = nil

        for _, win_id in ipairs(windows) do
          local buf_id = vim.api.nvim_win_get_buf(win_id)
          local buf_name = vim.api.nvim_buf_get_name(buf_id)
          local buf_type = vim.api.nvim_buf_get_option(buf_id, 'buftype')

          -- Omit fix windows
          if vim.wo[win_id].winfixbuf then break end

          -- Check for a window with no file opened
          if buf_name == "" then
            empty_window = win_id
            break
          end

          -- Check for a window with an editable file
          if buf_type == "" and vim.api.nvim_buf_get_option(buf_id, 'modifiable') then
            editable_window = win_id
          end
        end

        -- Open file in an empty window if available, otherwise in an editable window
        if empty_window then
          open_file_in_window(empty_window)
        elseif editable_window then
          open_file_in_window(editable_window)
        else
          -- If no suitable window found, create a vertical split
          vim.cmd('vsplit')
          vim.cmd('edit ' .. file_path)
        end

        on_complete(true, nil)
      end,
    }
end

return create_config

