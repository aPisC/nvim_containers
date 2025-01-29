function initialize_language_server(plug, opts)
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

        for _, extend_capabilities in pairs(opts.extend_capabilities) do
          capabilities = extend_capabilities(capabilities, server)
        end

        local on_attach = function(client, bufnr)
          if server_config.on_attach then server_config.on_attach(client, bufnr) end
          if capabilities.signature_help.enable then
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
end

function initialize_mason(plug, opts)
  require("mason").setup({})
  require("mason-tool-installer").setup({
    ensure_installed = vim.tbl_filter(
      function(package) return opts.mason_install[package] end,
      vim.tbl_keys(opts.mason_install)
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
            keymaps = {
               {'<F12>',  {n=":Telescope lsp_definitions<CR>"}, description="LSP Show definitions" },
               {'<F24>',  {n=":Telescope lsp_references<CR>"}, description="LSP Show references" },
               {'gd',     {n=":Telescope lsp_definitions<CR>"}, description="", hide=true },
               {'gr',     {n=":Telescope lsp_references<CR>"}, description="", hide=true },
               {'gi',     {n=":Telescope lsp_implementations<CR>"}, description="LSP Show implementations" },
               {'<F2>',   {n=vim.lsp.buf.rename}, description="LSP Rename symbol" },
               {'<M-CR>', {n=vim.lsp.buf.code_action, v=vim.lsp.buf.code_action, i=vim.lsp.buf.code_action }, description="LSP Code actions" },
               {'<M-S-CR>', {n=vim.lsp.codelens.run, v=vim.lsp.codelens.run, i=vim.lsp.codelens.run }, description="LSP Code actions" },
               {'K',      {n=vim.lsp.buf.hover}, description="LSP Hover" },
               {'<C-g>e', {n=vim.diagnostic.goto_next}, description="LSP Next diagnostic" },
               {'<C-?>',  {i=vim.lsp.buf.signature_help}, description="LSP Signature help" },
            }
          }
        }
      },
      'nvim-neotest/nvim-nio',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-lua/plenary.nvim',
      'williamboman/mason.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    lazy = false,
    opts = {
      servers = {},
      capabilities = {},
      mason_install =  {},
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
    },
    config = function(plug, opts)
      local init_components = {
        "mason",
        "treesitter",
        "formatter",
        "testing",
        "debugger",
        "linter",
        "language_server",
        "completion",
      }

      for _, component in ipairs(init_components) do
        if opts._initialize[component] then
          local _, error = pcall(
            opts._initialize[component],
            plug, 
            opts
          )
          if error then
            print("Error initializing " .. component .. ": " .. error)
          end
        end
      end
    end,
  },
}
