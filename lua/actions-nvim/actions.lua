local function fallback_action(name, err)
	err = err or "Unknown error"
	return function()
		vim.notify("Action '" .. name .. "' could not be loaded\n" .. err, vim.log.levels.ERROR)
	end
end

local function load_action(name)
	local success, action_or_error = pcall(require, "actions-nvim." .. name)
	if success then
		return action_or_error
	end
	return fallback_action(name, action_or_error)
end

local M = {
	_actions = {
		["find.file"] = load_action("find.file"),
		["find.class"] = load_action("find.class"),
		["find.symbol"] = load_action("find.symbol"),
		["find.local_symbol"] = load_action("find.local_symbol"),
		["find.local_text"] = load_action("find.local_text"),
		["find.text"] = load_action("find.text"),

		["jump.definition"] = load_action("jump.definition"),
		["jump.implementation"] = load_action("jump.implementation"),
		["jump.usages"] = load_action("jump.usages"),
		["jump.prev"] = load_action("jump.prev"),
		["jump.next"] = load_action("jump.next"),
		["jump.recent_files"] = load_action("jump.recent_files"),

		["edit.line_duplicate"] = load_action("edit.line_duplicate"),
		["edit.line_delete"] = load_action("edit.line_delete"),
		["edit.line_move_up"] = load_action("edit.line_move_up"),
		["edit.line_move_down"] = load_action("edit.line_move_down"),
		["edit.line_join"] = load_action("edit.line_join"),
		["edit.line_comment"] = load_action("edit.line_comment"),
		["edit.block_comment"] = load_action("edit.block_comment"),
		["edit.format"] = load_action("edit.format"),

		["completion.open"] = load_action("completion.open"),
		["completion.open_context"] = load_action("completion.open_context"),
		["completion.show_parameter"] = load_action("completion.show_parameter"),
		["completion.show_documentation"] = load_action("completion.show_documentation"),
		["completion.show_actions"] = load_action("completion.show_actions"),

		["refactor.optiomize_imports"] = load_action("refactor.optiomize_imports"),
		["refactor.rename"] = load_action("refactor.rename"),
		["refactor.change_signature"] = load_action("refactor.change_signature"),
		["refactor.extract_method"] = load_action("refactor.extract_method"),
		["refactor.extract_variable"] = load_action("refactor.extract_variable"),
		["refactor.extract_field"] = load_action("refactor.extract_field"),
		["refactor.extract_constant"] = load_action("refactor.extract_constant"),
		["refactor.inline"] = load_action("refactor.inline"),
		["refactor.delete"] = load_action("refactor.delete"),
		["refactor.open"] = load_action("refactor.open"),

		["generate.surround_with"] = load_action("generate.surround_with"),
		["generate.code"] = load_action("generate.code"),
		["generate.override"] = load_action("generate.override"),
		["generate.implementation"] = load_action("generate.implementation"),

		["debug.toggle_breakpoint"] = load_action("debug.toggle_breakpoint"),
		["debug.start_debug"] = load_action("debug.start_debug"),
		["debug.start_run"] = load_action("debug.start_run"),
		["debug.start_last"] = load_action("debug.start_last"),
		["debug.step_over"] = load_action("debug.step_over"),
		["debug.step_into"] = load_action("debug.step_into"),
		["debug.step_out"] = load_action("debug.step_out"),
		["debug.continue"] = load_action("debug.continue"),
		["debug.stop"] = load_action("debug.stop"),
		["debug.eval_expression"] = load_action("debug.eval_expression"),

		["select.multi_next"] = load_action("select.multi_next"),
		["select.multi_all"] = load_action("select.multi_all"),
		["select.block"] = load_action("select.block"),
		["select.expand_up"] = load_action("select.expand_up"),
		["select.expand_down"] = load_action("select.expand_down"),

		["tools.terminal"] = load_action("tools.terminal"),
    ["toold.diagnostics"] = load_action("tools.diagnostics"),

		["neovide.scale_up"] = load_action("neovide.scale_up"),
		["neovide.scale_down"] = load_action("neovide.scale_down"),
		["neovide.scale_reset"] = load_action("neovide.scale_reset"),
		["neovide.paste"] = load_action("neovide.paste"),
		["neovide.new_window"] = load_action("neovide.new_window"),
		["neovide.toggle_gobi_mode"] = load_action("neovide.toggle_gobi_mode"),
		["neovide.toggle_opacity"] = load_action("neovide.toggle_opacity"),
	},
}

return setmetatable(M, {
	__index = function(self, key)
		if not self._actions[key] then
			self._actions[key] = load_action(key)
		end
		return function(...)
			return self._actions[key](...)
		end
	end,
})
