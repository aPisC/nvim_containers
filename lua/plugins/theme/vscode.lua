return {
  {
    'Mofiqul/vscode.nvim',
    opts = {
      style = "dark",
      transparent = false,
      italic_comments = true,
      group_overrides = {

        NotifyINFOTitle =  { fg="vscUiBlue" },
        NotifyINFOIcon =  { fg="vscUiBlue" },
        NotifyINFOBorder =  { fg="vscUiBlue" },
        NotifyWARNTitle =  { fg="vscUiOrange" },
        NotifyWARNIcon =  { fg="vscUiOrange" },
        NotifyWARNBorder =  { fg="vscUiOrange" },
        NotifyBackground =  { bg="vscPopupBack" },

        CmpGhostText   = { fg='vscGray' },
        CopilotAnnotation = { fg='vscGray' },
        CopilotSuggestion = { fg='vscGray' },

        NavicIconsFile = { link="Structure" },
        NavicIconsModule = { link="Structure" },
        NavicIconsNamespace = { link="Structure" },
        NavicIconsPackage = { link="Structure" },
        NavicIconsClass = { link="Structure" },
        NavicIconsMethod = { link="Function" },
        NavicIconsProperty = { link="Identifier" },
        NavicIconsField = { link="Identifier" },
        NavicIconsConstructor = { link="Structure" },
        NavicIconsEnum = { link="Type" },
        NavicIconsInterface = { link="Type" },
        NavicIconsFunction = { link="Function" },
        NavicIconsVariable = { link="Identifier" },
        NavicIconsConstant = { link="Constant" },
        NavicIconsString = { link="String" },
        NavicIconsNumber = { link="Number" },
        NavicIconsBoolean = { link="Boolean" },
        NavicIconsArray = { link="Structure" },
        NavicIconsObject = { link="Structure" },
        NavicIconsKey = { link="Identifier" },
        NavicIconsNull = { link="Special" },
        NavicIconsEnumMember = { link="Identifier" },
        NavicIconsStruct = { link="Structure" },
        NavicIconsEvent = { link="Type" },
        NavicIconsOperator = { link="Operator" },
        NavicIconsTypeParameter = { link="Type" },
        NavicText = { fg="vscFront" },
        NavicSeparator = { fg="vscSplitLight" },
      }
    },
    lazy = false,
    priority = 1000,
    config = function(plug, opts)
      vim.o.background = 'dark'
      local vscode = require('vscode')
      local c = require('vscode.colors').get_colors()

      local resolved_opts = vim.tbl_extend("force",
        opts,
        {
           group_overrides = vim.tbl_map(function(group)
              return vim.tbl_map(function(value)
                if type(value) == "string" and c[value] then
                  return c[value]
                end
                return value
              end, group)
           end, opts.group_overrides)
        }
      )

      vscode.setup(resolved_opts)
      vscode.load()
    end
  },
}
