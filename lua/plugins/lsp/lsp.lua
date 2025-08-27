local Promise = require"promise"

function initialize_language_server(plug, opts)
      if not opts.servers then return end

      -- setup LSP servers
      local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local lspconfig = require("lspconfig")

      for server, server_config in pairs(opts.servers) do
        if type(server_config) == "function" then server_config = server_config() end
        local capabilities = vim.tbl_deep_extend("force",
          {},
          vim.lsp.protocol.make_client_capabilities(),
          has_cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities() or {},
          server_config.capabilities or {}
        ) 

        for _, extend_capabilities in pairs(opts.extend_capabilities or {}) do
          capabilities = extend_capabilities(capabilities, server)
        end

        local on_attach = function(client, bufnr)
          if server_config.on_attach then server_config.on_attach(client, bufnr) end
          if capabilities.signature_help and capabilities.signature_help.enable then
            require("lsp_signature").on_attach(capabilities.signature_help, bufnr)
          end
          -- if capabilities.use_virtual_types then
            -- require("virtual-types").on_attach(client, bufnr)
          -- end
        end

        if server_config.lspDefaultCapabilities == false then capabilities = server_config.capabilities end

        local config = vim.tbl_deep_extend("force", {}, server_config, { capabilities = capabilities, on_attach = on_attach })

        local has_coq, coq = pcall(require, "coq")
        config = has_coq and coq.lsp_ensure_capabilities(config) or config

        lspconfig[server].setup(config)
      end

      -- Initialize EFM
      local efm_capabilities = vim.tbl_deep_extend("force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities() or {},
        opts.efm.capabilities or {}
      ) 

      for _, extend_capabilities in pairs(opts.extend_capabilities or {}) do
        efm_capabilities = extend_capabilities(efm_capabilities, server)
      end

      local efm_on_attach = function(client, bufnr)
        if opts.efm.on_attach then opts.efm.on_attach(client, bufnr) end
        if efm_capabilities.signature_help and efm_capabilities.signature_help.enable then
          require("lsp_signature").on_attach(capabilities.signature_help, bufnr)
        end
        -- if capabilities.use_virtual_types then
          -- require("virtual-types").on_attach(client, bufnr)
        -- end
      end

      local efmls_config = {
        filetypes = vim.tbl_keys(opts.efm),
        settings = {
          rootMarkers = { '.git/' },
          languages = vim.tbl_map(
            function(lang_config)
              return vim.tbl_map(
                function(module)
                  if type(module) == "function" then return module() end
                  if type(module) == "string" then return require(module) end
                  return module
                end,
                lang_config
              )
            end,
            opts.efm
          )
        },
        init_options = {
          documentFormatting = true,
          documentRangeFormatting = true,
        },
        capabilities = efm_capabilities,
        on_attach = efm_on_attach,
      }
      lspconfig.efm.setup(efmls_config)

end

function initialize_language_server_lazy(config)
  return Promise.new(function(resolve)
    if config.servers then
      for server, server_config in pairs(config.servers) do
          vim.defer_fn(function()
            pcall(function()
              vim.notify('Starting LSP server ' .. server)
              require('lspconfig')[server].setup(server_config)
              vim.cmd("LspStart ".. server) 
            end)
          end, 0)
      end
    end
    resolve()
  end)
end

function initialize_mason(plug, opts)

  require("mason").setup({})
  require("mason-tool-installer").setup({
    ensure_installed = vim.tbl_filter(
      function(package) return opts.mason_install[package] end,
      vim.tbl_keys(opts.mason_install or {})
    ),
    auto_update = false,
    run_on_start = true,
    start_delay = 3000,
  })
  require("mason-lspconfig").setup({
    ensure_installed = {},
    automatic_installion = true,
  })
end

local function initialize_mason_lazy(opts)
  return Promise._then(
    vim.tbl_map(
      function(package) 
        return Promise.new(function(resolve)
          local Package = require "mason-core.package"
          local registry = require "mason-registry"

          if not opts.mason_install[package] then return resolve() end
          if registry.is_installed(package) then return resolve() end

          vim.notify("[Mason] Installing package " .. package, "info")
          local package_name, version = Package.Parse(package)
          local pkg = registry.get_package(package_name)
          local handle =  pkg:install({ version = version })


          local callback = function()
            if not handle.package:is_installed() then
              vim.notify("[Mason] Failed to install package " .. package_name, "error")
            else 
              vim.notify("[Mason] Installed package " .. package_name, "info")
            end
            resolve()
          end

          if handle:is_closed() then
            callback()
          else
            handle:once("closed", callback)
          end
        end)
      end,
      vim.tbl_keys(opts.mason_install or {})
    )
  )
end

local function initialize_plugins_lazy(opts)
  -- :lua = require"lazy".install({plugins = require"lazy.core.plugin".Spec.new({"Hoffs/omnisharp-extended-lsp.nvim"}).plugins, wait=false, show=false, clear=false})._running:on("done", function() vim.notify("doooone") end)
  local plugins = vim.tbl_filter(
    function(plugin) return opts.plugins[plugin] end,
    vim.tbl_keys(opts.plugins or {})
  )
  if #plugins == 0 then return Promise.resolved() end

  local spec = require"lazy.core.plugin".Spec.new(plugins)
  local missing_plugins = vim.tbl_filter(
    function(plugin) 
      local dir = plugin.dir
      local dirstat = vim.loop.fs_stat(dir)
      return not dirstat
    end,
    spec.plugins
  )
  if #missing_plugins == 0 then return Promise.resolved() end

  return Promise.new(function(resolve)
    vim.notify("Installing plugins " .. table.concat(plugins, ", "), "info")
    require"lazy".install({plugins = spec.plugins, wait=false, show=true, clear=false})._running:on("done", resolve)
  end)
end

return {
  {
    -- LSP config
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'mrjones2014/legendary.nvim',
        opts = {
          ["nvim-lspconfig"] = {
            icon = '󰢊',
            itemgroup = "LSP",
            commands = {
              { ':LspHintInspect', require('utils.lsp-inspect-hint').inspect_hint, description = 'Inspect inlay hints' },
              { ':LspHintEnable', function() vim.lsp.inlay_hint.enable(true) end, description = 'Enable inlay hints' },
              { ':LspHintDisable', function() vim.lsp.inlay_hint.enable(false) end, description = 'Disable inlay hints' },
            },
            keymaps = {
               {'<F12>',  {n=":Telescope lsp_definitions<CR>"}, description="LSP Show definitions" },
               {'<F24>',  {n=":Telescope lsp_references<CR>"}, description="LSP Show references" },
               {'gd',     {n=":Telescope lsp_definitions<CR>"}, description="LSP Show definitions" },
               {'gr',     {n=":Telescope lsp_references<CR>"}, description="LSP Show references" },
               {'gi',     {n=":Telescope lsp_implementations<CR>"}, description="LSP Show implementations" },
               {'gk',     {n=function() vim.diagnostics.setloclist() end}, description="LSP show diagnostics in loclist"},
               {'gK',     {n=":Telescope diagnostics<CR>"}, description="LSP Show workspace diagnostic" },
               {'gp',     {n=":Telescope lsp_document_symbols<CR>"}, description="LSP Show document symbols" },
               {
                 '<C-f>',     
                 { n = function(ev) 
                     -- local efm = vim.lsp.get_active_clients({ name = 'efm', bufnr = vim.api.nvim_get_current_buf() })

                     -- if vim.tbl_isempty(efm) then 
                     -- else
                     --   vim.lsp.buf.({ name = 'efm' })
                     -- end
                     --
                     local lspconfig = require("lspconfig")
                     local efm_modules = vim.tbl_get(lspconfig, "efm", "manager", "config", "settings", "languages", vim.bo.filetype) or {}
                     local has_efm_formatter = vim.tbl_filter(
                       function(module) return module.formatCommand end,
                       efm_modules
                     )[1] ~= nil

                     if has_efm_formatter then
                       vim.lsp.buf.format({ name = "efm" })
                     else
                       vim.lsp.buf.format()
                     end
                 end }, 
                 description="LSP Format"
               },
               {
                  'gP',     
                  { n = function()
                    local query = vim.fn.input("Search for: ")
                    if query == "" or query == nil then
                      vim.cmd(":Telescope lsp_dynamic_workspace_symbols")
                    else
                      vim.cmd(":Telescope lsp_workspace_symbols query=" .. query)
                    end
                  end
                }, 
                description="LSP Show workspace diagnostic" 
               },
               {'<F2>',   {n=vim.lsp.buf.rename}, description="LSP Rename symbol" },
               {
                 '<M-CR>', 
                 {
                   n=function() require"super_lens".run() end, 
                   v=function() require"super_lens".run() end, 
                   i=function() require"super_lens".run() end, 
                 }, 
                 description="LSP Code actions" 
               },
               {'<M-S-CR>', {n=vim.lsp.codelens.run, v=vim.lsp.codelens.run, i=vim.lsp.codelens.run }, description="LSP Code lens" },
               {'K',      {n=vim.lsp.buf.hover}, description="LSP Hover" },
               {'<C-g>e', {n=vim.diagnostic.goto_next}, description="LSP Next diagnostic" },
               {'<C-?>',  {i=vim.lsp.buf.signature_help}, description="LSP Signature help" },
            }
          }
        }
      },
      {
        enabled=true,
        dir = "~/.config/nvim/lua/super_lens",
      },
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'williamboman/mason.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'williamboman/mason-lspconfig.nvim',
      'creativenull/efmls-configs-nvim',
    },
    lazy = false,
    opts = {
      plugins = {},
      servers = {},
      efm = {},
      capabilities = {},
      mason_install =  {
        efm = true,
      },
      extend_capabilities = {
        signature_help = function(capabilities, server)
          return vim.tbl_deep_extend("force", capabilities, {
            signature_help = {
              signature_help = true,
              handler_opts = { border = "rounded" },
              hint_enable = false,
            }
          })
        end
      }, 
      _initialize = {
        mason = initialize_mason,
        language_server = initialize_language_server,
      },
      _initialize_lazy = {
        plugins = initialize_plugins_lazy,
        mason = initialize_mason_lazy,
        language_server = initialize_language_server_lazy

      },
    },
    config = function(plug, opts)
      local init_components = {
        "plugins",
        "mason",
        "treesitter",
        "formatter",
        "testing",
        "debugger",
        "linter",
        "language_server",
        "completion",
      }

      -- Preloader
      local preloaded_modules = vim.tbl_filter(function(module) return ((not opts.modules[module].lazy) and opts.modules[module].auto) end, vim.tbl_keys(opts.modules))
      local preload_config = vim.tbl_deep_extend("force", {}, opts)
      for _, module in ipairs(preloaded_modules) do preload_config = vim.tbl_deep_extend("force", preload_config, opts.modules[module]) end

      for _, component in ipairs(init_components) do
        if opts._initialize[component] then
          local _, error = pcall(
            opts._initialize[component],
            plug, 
            preload_config
          )
          if error then
            print("Error initializing " .. component .. ": " .. error)
          end
        end
      end



      -- Lazy loader
        function lazy_load_module(module_name)
          Promise._join(
            Promise._then(
              vim.tbl_map(
                function(component)
                  if opts._initialize_lazy[component] then
                    return Promise.catch(
                      opts._initialize_lazy[component](opts.modules[module_name]),
                      function(error)
                        vim.notify("[LSP] Error initializing " .. component .. "\n\n" .. error, "error")
                      end
                    )
                  end
                  return Promise.resolved()
                end,
                init_components
              )
            ) 
          )
        end

        local filetype_handled = {}
        local module_handled = {}

        local augroup = vim.api.nvim_create_augroup("lsp-lazyloading", { clear = true })
        vim.api.nvim_create_autocmd({"Filetype"}, {callback=function() 
          local filetype = vim.bo.filetype
          if filetype_handled[filetype] then return false end

          local lazy_module_keys = vim.tbl_filter(
              function(module_name)
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
            end, 
            vim.tbl_keys(opts.modules)
          )

          if #lazy_module_keys == 0 then 
            filetype_handled[filetype] = true
            return
          end


          vim.tbl_map(
            function(module_name)
              if module_handled[module_name] then return end
              if not opts.modules[module_name].lazy then return end 

              if opts.modules[module_name].auto then
                module_handled[module_name] = true
                filetype_handled[filetype] = true
                lazy_load_module(module_name)
                return
              end

              vim.ui.select(
                { 'yes', 'no' }, 
                { prompt = 'Would you like to enable ' .. module_name .. ' support?' }, 
                function(choice)
                  module_handled[module_name] = true
                  filetype_handled[filetype] = true
                  if choice == 'yes' then
                    lazy_load_module(module_name)
                  end
                end
              )
            end, 
            lazy_module_keys
          )
        end})

        vim.api.nvim_create_user_command("LspLoad", function(args)
          if not opts.modules[args.args] then 
            vim.notify("Module " .. args.args .. " not found", "error")
            return
          end
          if not module_handled[args.args] then
            module_handled[args.args] = true
            lazy_load_module(args.args)
          end
        end, {nargs="?"})


        -- Lazy loader end
    end,
  },
}
