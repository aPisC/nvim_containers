local M = {}

function M.get_os()
    -- Get the system's OS name
    local os_name = vim.loop.os_uname().sysname:lower()

    if os_name:find("linux") then
        return "linux"
    elseif os_name:find("windows") then
        return "windows"
    elseif os_name:find("darwin") then
        return "mac"
    end

    return "unknown"
  end

function M.cond(os_table)
    -- Get the system's OS name
    local os_name = M.get_os()

    local linux_value = os_table.linux

    if os_name == "linux" then
        return linux_value
    elseif os_name == "windows" then
        return os_table.windows or linux_value
    elseif os_name == "mac" then
        return os_table.mac or linux_value
    end

    return linux_value
end



return M
