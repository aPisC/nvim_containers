return {
    {
      'mrjones2014/legendary.nvim',
      dependencies = { },
      opts = { },
      config = function(_, opts) 
        local config = {
          extensions = {
            lazy_nvim = true,
          },
          keymaps = {}
        }

        for module_name, module_opts in pairs(opts) do
          table.insert(config.keymaps, {
            itemgroup = module_opts.itemgroup or module_name,
            icon = module_opts.icon,
            description = module_opts.description,
            keymaps = module_opts.keymaps,
          })
        end

        require("legendary").setup(config)
      end
    },
}
