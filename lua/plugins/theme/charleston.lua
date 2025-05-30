return {
  {
    'romanaverin/charleston.nvim',
    name = 'charleston',
    opts = {
      terminal_colors = true,
      italic = true,
      darken_background = false,
      
      custom_colors = {
        diff_change_bg = "#2a2e46",
        diff_text_bg = "#1c4354"
      },
      -- Custom highlight group overrides similar to vscode theme
      -- These can be added based on your preferences
      group_overrides = {
        -- Notify plugin
        NotifyINFOTitle = { fg = "${blue}" },
        NotifyINFOIcon = { fg = "${blue}" },
        NotifyINFOBorder = { fg = "${blue}" },
        NotifyWARNTitle = { fg = "${orange}" },
        NotifyWARNIcon = { fg = "${orange}" },
        NotifyWARNBorder = { fg = "${orange}" },
        NotifyBackground = { bg = "${bg}" },
        
        -- Completion and Copilot
        CmpGhostText = { fg = "${charcoal}" },
        CopilotAnnotation = { fg = "${charcoal}" },
        CopilotSuggestion = { fg = "${charcoal}" },
        
        -- Navic icons (similar structure to vscode theme)
        NavicIconsFile = { link = "Structure" },
        NavicIconsModule = { link = "Structure" },
        NavicIconsNamespace = { link = "Structure" },
        NavicIconsPackage = { link = "Structure" },
        NavicIconsClass = { link = "Structure" },
        NavicIconsMethod = { link = "Function" },
        NavicIconsProperty = { link = "Identifier" },
        NavicIconsField = { link = "Identifier" },
        NavicIconsConstructor = { link = "Structure" },
        NavicIconsEnum = { link = "Type" },
        NavicIconsInterface = { link = "Type" },
        NavicIconsFunction = { link = "Function" },
        NavicIconsVariable = { link = "Identifier" },
        NavicIconsConstant = { link = "Constant" },
        NavicIconsString = { link = "String" },
        NavicIconsNumber = { link = "Number" },
        NavicIconsBoolean = { link = "Boolean" },
        NavicIconsArray = { link = "Structure" },
        NavicIconsObject = { link = "Structure" },
        NavicIconsKey = { link = "Identifier" },
        NavicIconsNull = { link = "Special" },
        NavicIconsEnumMember = { link = "Identifier" },
        NavicIconsStruct = { link = "Structure" },
        NavicIconsEvent = { link = "Type" },
        NavicIconsOperator = { link = "Operator" },
        NavicIconsTypeParameter = { link = "Type" },
        NavicText = { fg = "${text}" },
        NavicSeparator = { fg = "${text}" },

        DiffChange = { bg = "${diff_change_bg}" },
        DiffText = { bg = "${diff_text_bg}" },
        DiffDelete = { bg = "${diff_delete_bg}" },

        RenderMarkdownCode = { bg = "${bg_dimmed}", fg = "NONE" },
      }
    },
    lazy = false,
    priority = 1000,
    config = function(plug, opts)
      local charleston = require('charleston')
      local colors = vim.tbl_deep_extend("force", {}, require('charleston.colors').palette, opts.custom_colors or {})

      local resolved_overrides = vim.tbl_map(
        function(override)
          return vim.tbl_map(
            function(value)
              if type(value) == "string" and value:match("^%${(.+)}$") then
                local color_name = value:match("^%${(.+)}$")
                if colors[color_name] then return colors[color_name]
                else error("Color '" .. color_name .. "' is not defined in the charleston color palette")
                end
              end
              return value
            end, 
            override
          )
        end, 
        opts.group_overrides
      )

      charleston.setup(opts)
      vim.o.background = 'dark'
      vim.cmd.colorscheme "charleston"
      charleston.load()

      -- Set up a hook to apply overrides after colorscheme is loaded
      for group_name, group_settings in pairs(resolved_overrides) do
        vim.api.nvim_set_hl(0, group_name, group_settings)
      end
    end

  },
}
