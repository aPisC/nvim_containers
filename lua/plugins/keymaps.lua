return {
    {
      'mrjones2014/legendary.nvim',
      opts = { },
      config = function(_, opts) 
        local legendary = require("legendary")
        local keymaps = {}

        for module_name, module in pairs(opts) do
          for _, keymap in ipairs(module.keymaps or {}) do
            keymap = vim.tbl_deep_extend("force", {  }, keymap)
            table.insert(keymaps, keymap)
          end
        end


        local config = {
          keymaps = keymaps,
        }
        legendary.setup(config)
      end
    },
}
