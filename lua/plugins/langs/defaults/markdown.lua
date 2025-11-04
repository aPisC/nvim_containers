return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		opts = {
			file_types = { "markdown" },
			sign = { enabled = true, },
      heading = {
        icons = {'󰫎 ', '  󰫎 ', '    󰫎 ', '      󰫎 ', '        󰫎 ', '          󰫎 '},
        border = true,
        border_virtual = true,
        width = 'full',
      },
      checkbox = { 
        enabled = true,
        right_pad = 0,
        unchecked = {
            icon = '  󰄱 ',
            highlight = 'RenderMarkdownUnchecked',
            scope_highlight = nil,
        },
        checked = {
            icon = '  󰱒 ',
            highlight = 'RenderMarkdownChecked',
            scope_highlight = nil,
        },
      },
      code = {
      }
		},
		ft = { "markdown" },
	},
}
