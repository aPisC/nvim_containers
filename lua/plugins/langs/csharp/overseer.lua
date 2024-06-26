
local function get_sln_path() 
  local path = vim.fs.find(
    function(name) return name:match(".*%.sln") end,
    {
      upward = true,
      type = "file",
      path = vim.fn.getcwd(),
      stop = vim.fn.getcwd(),
    }
  )[1]
  return path
end


local function read_env_file(path)
  local files = require("overseer.files")
  local content = files.read_file(path)

  local env = {}
  for line in content:gmatch("[^\r\n]+") do
    if not line:match("^ *#") then
      local key, value = line:match(" *([^=]+)=(.*)")
      if key and value then
        env[key] = value
      end
    end
  end

  return env
end

return {
    {
    'aPisC/overseer.nvim',
    opts = {
      custom_templates = {
        scala = {
          name="scala tasks",
          generator = function(search, cb)
            local slnFile = get_sln_path()

            local ret = {
              {
                name = "dotnet build sln",
                tags = {"dotnet"},
                params = {},
                condition = {},
                builder = function() return {
                  cmd = {"dotnet", "compile" },
                  args = {"build", slnFile},
                  cwd = vim.fn.getcwd(),
                  env = {},
                  name = "Dotnet build solution",
                  components = {"default"},
                  metadata = {},
                } end,
              },
            }

            local run_projects = {}
            local test_projects = {}
            local jid = vim.fn.jobstart({"dotnet", "sln", "list"}, {
              stdout_buffered = true,
              on_stdout = function(_, data, _)
                local separator_found = false
                for _, line in ipairs(data) do
                  if not separator_found then
                    if line:match("^-*$") then separator_found = true end
                  else
                    if line == "" then
                    elseif line:match(".*Tests?.csproj") then table.insert(test_projects, line)
                    else table.insert(run_projects, line) end
                  end
                end
              end,
            })
            vim.fn.jobwait({jid})



            for _, project in ipairs(run_projects) do
              table.insert(ret, {
                name = "dotnet run" .. project,
                tags = {"dotnet"},
                params = {
                  envFile = {
                    type = "string",
                    default = vim.fn.filereadable(".vscode/.env") == 1 and ".vscode/.env" or "",
                    description = "Path to the env file",
                    validate = function(value)
                      return value == "" or vim.fn.filereadable(value) == 1
                    end
                  },
                },
                condition = {},
                builder = function(params) 
                  args = {
                    "project "  .. project,
                    "run"
                  }
                  return {
                    cmd = "dotnet",
                    args = {"build", project},
                    cwd = vim.fn.getcwd(),
                    env = params.envFile == "" and {} or read_env_file(params.envFile),
                    name = "Run " .. project,
                    components = {"default"},
                    metadata = {},
                  } 
                end,
              })
            end

            for _, project in ipairs(test_projects) do
              table.insert(ret, {
                name = "dotnet test " .. project,
                tags = {"dotnet"},
                params = {},
                condition = {},
                builder = function() return {
                  cmd = "dotnet",
                  args = {"test", project},
                  cwd = vim.fn.getcwd(),
                  env = {},
                  name = "Test " .. project,
                  components = {"default"},
                  metadata = {},
                } end,
              })
            end
            cb(ret)
          end,
          condition = {
            callback = function()
              return get_sln_path() ~= nil
            end,
          },
          cache_key = function()
            return get_sln_path()
          end
        }
      }
    }
  }
}
