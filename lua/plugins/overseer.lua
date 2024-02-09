function get_overseer_tasks_file(dir)
  local files = require("overseer.files")
  local vscode_dirs = vim.fs.find(".vscode", { upward = true, type = "directory", path = dir, limit = math.huge })
  for _, vscode_dir in ipairs(vscode_dirs) do
    local tasks_file = files.join(vscode_dir, "overseer.json")
    if files.exists(tasks_file) then return tasks_file end
  end
end

function transform_json_component(component) 
  if type(component) == "string" then return component 
  elseif type(component) == "table" then return vim.tbl_extend("force", { component[1] }, component[2] or {}) 
  else return nil end
end

return {
  {
    'aPisC/overseer.nvim',
    dependencies = {
      {
        'stevearc/dressing.nvim',
        opts = {},
      }
    },
    opts = {
      templates = {"builtin"},
      task_list = {
        bindings = {
          ["o"] = "<CMD>OverseerRun<CR>",
          ["i"] = "<CMD>OverseerQuickAction edit<CR>",
          ["r"] = "<CMD>OverseerQuickAction restart<CR>",
          ["w"] = "<CMD>OverseerQuickAction watch<CR>",
          ["x"] = "<CMD>OverseerQuickAction dispose<CR>",
          ["f"] = "<CMD>OverseerQuickAction open float<CR>",
          ["t"] = "<CMD>OverseerQuickAction open tab<CR>",
          ["dd"] = "<CMD>OverseerQuickAction dispose<CR>",
        },
      },
    },
    event = "VeryLazy",
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)

      local files = require("overseer.files")
      overseer.register_template({
        name = "overseer.json",
        generator = function(search, cb)
          local task_file_path = get_overseer_tasks_file(vim.fn.getcwd())
          if not task_file_path then return cb({}) end

          local task_file = files.load_json_file(task_file_path)

          local ret = {}
          for _, task in ipairs(task_file.tasks) do
            table.insert(ret, {
              name = task.name,
              desc = task.desc,
              priority = task.priority,
              tags = task.tags,
              params = task.params,
              condition = task.condition,
              builder = function() return {
                  strategy = task.strategy and transform_json_component(task.strategy) or nil,
                  cmd = task.cmd,
                  args = task.args,
                  cwd = task.cwd,
                  env = task.env,
                  name = task.name,
                  components = vim.tbl_map(transform_json_component, task.components or {"default"}),
                  metadata = task.metadata,
              } end,
            })
          end

          cb(ret)
        end,

        condition = {
          callback = function(search)
            return get_overseer_tasks_file(vim.fn.getcwd()) ~= nil
          end,
        },

        cache_key = function(opts)
          return get_overseer_tasks_file(vim.fn.getcwd()) or ""
        end,
      })
    end,
  }
}
