
function get_build_sbt_path() 
  local path = vim.fs.find("build.sbt", {
    upward = true,
    type = "file",
    path = vim.fn.getcwd(),
  })[1]
  return path
end


function read_env_file(path)
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
            local ret = {
              {
                name = "sbt compile all",
                tags = {"scala", "sbt"},
                params = {},
                condition = {},
                builder = function() return {
                  cmd = {"sbt", "compile" },
                  args = {},
                  cwd = vim.fn.getcwd(),
                  env = {},
                  name = "Sbt Compile",
                  components = {"default"},
                  metadata = {},
                } end,
              },
              {
                name = "sbt",
                tags = {"scala", "sbt"},
                params = {},
                condition = {},
                builder = function(opts) return {
                  cmd = {"sbt" },
                  args = {},
                  cwd = vim.fn.getcwd(),
                  env = {},
                  name = "Sbt",
                  components = {"default"},
                  metadata = {},
                } end,
              }
            }

            local run_projects = {}
            local test_projects = {}
            local jid = vim.fn.jobstart({"bloop", "projects"}, {
              stdout_buffered = true,
              on_stdout = function(_, data, _)
                for _, line in ipairs(data) do
                  if line == "" then  
                  elseif line:match("^default-.*") then  
                  elseif line:match(".*test") then table.insert(test_projects, line)
                  else table.insert(run_projects, line) end
                end
              end,
            })
            vim.fn.jobwait({jid})



            for _, project in ipairs(run_projects) do
              table.insert(ret, {
                name = "sbt run " .. project,
                tags = {"scala", "sbt"},
                params = {
                  envFile = {
                    type = "string",
                    default = vim.fn.filereadable(".vscode/.env") == 1 and ".vscode/.env" or "",
                    description = "Path to the env file",
                    validate = function(value)
                      return value == "" or vim.fn.filereadable(value) == 1
                    end
                  },
                  javaConfigFile = {
                    type = "string",
                    default = vim.fn.filereadable(".vscode/localdev.conf") == 1 and ".vscode/localdev.conf" or "",
                    description = "Path to the java config file",
                    validate = function(value)
                      return value == "" or vim.fn.filereadable(value) == 1
                    end
                  }
                },
                condition = {},
                builder = function(params) 
                  args = {
                    "project "  .. project,
                    params.javaConfigFile and ('set javaOptions += "-Dconfig.file=' .. vim.fn.getcwd() .. '/' .. params.javaConfigFile ..  '"' ) or nil,
                    "run"
                  }
                  return {
                    cmd = "sbt",
                    args = vim.tbl_filter(function(v) return v ~= nil end, args),
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
                name = "sbt test " .. project,
                tags = {"scala", "sbt"},
                params = {},
                condition = {},
                builder = function() return {
                  cmd = {"sbt", "project "  .. project ..";test" },
                  args = {},
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
            callback = function(opts)
              return get_build_sbt_path() ~= nil
            end,
          },
          cache_key = function(opts)
            return get_build_sbt_path()
          end
        }
      }
    }
  }
}
