local Promise = require("promise")


return {
	{
		-- LSP config
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"mrjones2014/legendary.nvim",
				opts = {
				},
			},
			{
				enabled = true,
				dir = "~/.config/nvim/lua/super_lens",
			},
			"icholy/lsplinks.nvim",
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"creativenull/efmls-configs-nvim",
			-- unpack(dependencies),
		},
		lazy = false,
		opts = {
      modules = {
				plugin_installer = nil,
				tool_installer = nil,
				treesitter = nil,
				formatter = nil,
				testing = nil,
				debugger = nil,
				linter = nil,
				language_servers = nil,
				completion = nil,
      },
			plugins = {},
			servers = {},
			efm = {},
			capabilities = {},
			mason_install = {
				efm = true,
			},
			extend_capabilities = {
				signature_help = function(capabilities, server)
					return vim.tbl_deep_extend("force", capabilities, {
						signature_help = {
							signature_help = true,
							handler_opts = { border = "rounded" },
							hint_enable = false,
						},
					})
				end,
			},
			_initialize = {
			},
			_initialize_lazy = {
			},
		},
		config = function(plug, opts)
			local init_components = {
				"plugin_installer",
				"tool_installer",
				"treesitter",
				"formatter",
				"testing",
				"debugger",
				"linter",
				"language_servers",
				"completion",
			}

      local modules = {}
      vim.tbl_map(function(module)
        local import_name = opts.modules and opts.modules[module]
        modules[module] = import_name and require("plugins.lsp." .. import_name) or nil
      end, init_components)
      
			for _, component in ipairs(init_components) do
        if modules[component] then
          modules[component].setup(opts)
        elseif opts._initialize[component] then
					local _, error = pcall(opts._initialize[component], plug, opts)
					if error then
						print("Error initializing " .. component .. ": " .. error)
					end
				end
			end




			-- Preloader
			-- local preloaded_modules = vim.tbl_filter(function(module)
			-- 	return ((not opts.modules[module].lazy) and opts.modules[module].auto)
			-- end, vim.tbl_keys(opts.modules))
			-- local preload_config = vim.tbl_deep_extend("force", {}, opts)
			-- for _, module in ipairs(preloaded_modules) do
			-- 	preload_config = vim.tbl_deep_extend("force", preload_config, opts.modules[module])
			-- end
			-- Lazy loader
			function lazy_load_module(module_name)
				Promise._join(Promise._then(vim.tbl_map(function(component)
					if opts._initialize_lazy[component] then
						return Promise.catch(
							opts._initialize_lazy[component](opts.modules[module_name]),
							function(error)
								vim.notify("[LSP] Error initializing " .. component .. "\n\n" .. error, "error")
							end
						)
					end
					return Promise.resolved()
				end, init_components)))
			end

			local filetype_handled = {}
			local module_handled = {}

			local augroup = vim.api.nvim_create_augroup("lsp-lazyloading", { clear = true })
			vim.api.nvim_create_autocmd({ "Filetype" }, {
				callback = function()
					local filetype = vim.bo.filetype
					if filetype_handled[filetype] then
						return false
					end

					local lazy_module_keys = vim.tbl_filter(function(module_name)
						if type(opts.modules[module_name].filetype) == "function" then
							return opts.modules[module_name]()
						end
						if type(opts.modules[module_name].filetype) == "table" then
							return vim.tbl_contains(opts.modules[module_name].filetype, filetype)
						end
						if type(opts.modules[module_name].filetype) == "string" then
							return opts.modules[module_name].filetype == filetype
						end
						return module_name == filetype
					end, vim.tbl_keys(opts.modules))

					if #lazy_module_keys == 0 then
						filetype_handled[filetype] = true
						return
					end

					vim.tbl_map(function(module_name)
						if module_handled[module_name] then
							return
						end
						if not opts.modules[module_name].lazy then
							return
						end

						if opts.modules[module_name].auto then
							module_handled[module_name] = true
							filetype_handled[filetype] = true
							lazy_load_module(module_name)
							return
						end

						vim.ui.select(
							{ "yes", "no" },
							{ prompt = "Would you like to enable " .. module_name .. " support?" },
							function(choice)
								module_handled[module_name] = true
								filetype_handled[filetype] = true
								if choice == "yes" then
									lazy_load_module(module_name)
								end
							end
						)
					end, lazy_module_keys)
				end,
			})

			vim.api.nvim_create_user_command("LspLoad", function(args)
				if not opts.modules[args.args] then
					vim.notify("Module " .. args.args .. " not found", "error")
					return
				end
				if not module_handled[args.args] then
					module_handled[args.args] = true
					lazy_load_module(args.args)
				end
			end, { nargs = "?" })

			-- Lazy loader end
		end,
	},
}
