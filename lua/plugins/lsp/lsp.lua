
return {
  {
    -- LSP config
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'mrjones2014/legendary.nvim',
        opts = {
          ["nvim-lspconfig"] = {
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
    },
    opts = {
      servers = {},
      capabilities = {
        -- use_virtual_types = true, -- Czzustom flag for auto attaching virtual types
        signature_help = {
          enable = false,
          bind = true, -- This is mandatory, otherwise border config won't get registered.
          handler_opts = { border = "rounded" },
          hint_enable = false,
        },
      },
    },
    config = function(plug, opts)
      local lspconfig = require("lspconfig")
      local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")


      for server, server_config in pairs(opts.servers) do
        local capabilities = vim.tbl_deep_extend( "force",
          {},
          vim.lsp.protocol.make_client_capabilities(),
          has_cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities() or {},
          opts.capabilities,
          server_config.capabilities or {}
        )

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
        lspconfig[server].setup(config)
      end

      -- show diagnostic on CursorHold
      local augrp = vim.api.nvim_create_augroup("LspCursorHold", {})
      vim.api.nvim_create_autocmd("CursorHold", {
        pattern = { "*" },
        callback = function()
          vim.diagnostic.open_float()
        end,
        group = augrp,
      })
    end,
    init = function()
      vim.diagnostic.config({
        underline=true,
        severity_sort=true,
        float = true,
        update_in_insert = true,
      })
    end
  },
}
