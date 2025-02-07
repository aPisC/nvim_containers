return {
  {
      "lervag/vimtex",
      lazy = false,
      priority = 40,
      init = function ()
        vim.g.vimtex_view_method = "zathura"
      end
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
        -- "micangl/cmp-vimtex",
    },
    opts = {
      mason_install = {
        ["texlab"] = true,
        ["bibtex-tidy"] = true
      },
      treesitter_install = { },
      formatters = {
        tex = { function() return require("formatter.defaults.prettier")("latex-parser") end },
        bib = {{
          exe = "bibtex-tidy",
          args = {
            "--v2=1",
            "--blank-lines=1",
            "--no-align=1",
            "--modify=1",
          },
          stdin = false,
        },
      }},
      cmp_filetype = {
        tex = {
          inherit = true,
          vimtex = { name = "vimtex" }
        }
      },
      servers = {
        texlab = {
          autostart = true,
          filetypes = { "tex", "bib" },
        }
      }
    }
  },
}
