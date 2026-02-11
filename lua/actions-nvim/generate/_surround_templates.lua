-- Surround templates
-- ${SELECTION} will be replaced with the selected text
-- Templates will be automatically indented to match the selection

local M = {}

M.templates = {
	{
		name = "if",
		template = [[
if ${CONDITION} then
${SELECTION}
end]],
		placeholders = { CONDITION = "condition" },
		filetypes = { "lua" },
	},
	{
		name = "if",
		template = [[
if (${CONDITION}) {
${SELECTION}
}]],
		placeholders = { CONDITION = "condition" },
		filetypes = { "javascript", "typescript", "java", "c", "cpp", "rust", "go", "scala" },
	},
	{
		name = "if",
		template = [[
if ${CONDITION}:
${SELECTION}]],
		placeholders = { CONDITION = "condition" },
		filetypes = { "python" },
	},
	{
		name = "while",
		template = [[
while ${CONDITION} do
${SELECTION}
end]],
		placeholders = { CONDITION = "condition" },
		filetypes = { "lua" },
	},
	{
		name = "while",
		template = [[
while (${CONDITION}) {
${SELECTION}
}]],
		placeholders = { CONDITION = "condition" },
		filetypes = { "javascript", "typescript", "java", "c", "cpp", "rust", "go", "scala" },
	},
	{
		name = "for",
		template = [[
for ${VAR} in ${ITERATOR} do
${SELECTION}
end]],
		placeholders = { VAR = "i", ITERATOR = "items" },
		filetypes = { "lua" },
	},
	{
		name = "for",
		template = [[
for (${INIT}; ${CONDITION}; ${INCREMENT}) {
${SELECTION}
}]],
		placeholders = { INIT = "let i = 0", CONDITION = "i < n", INCREMENT = "i++" },
		filetypes = { "javascript", "typescript", "java", "c", "cpp" },
	},
	{
		name = "try-catch",
		template = [[
try {
${SELECTION}
} catch (${ERROR}) {
${HANDLER}
}]],
		placeholders = { ERROR = "error", HANDLER = "console.error(error);" },
		filetypes = { "javascript", "typescript", "java", "scala" },
	},
	{
		name = "try-except",
		template = [[
try:
${SELECTION}
except ${EXCEPTION}:
${HANDLER}]],
		placeholders = { EXCEPTION = "Exception as e", HANDLER = "print(e)" },
		filetypes = { "python" },
	},
	{
		name = "function",
		template = [[
function ${NAME}(${PARAMS}) {
${SELECTION}
}]],
		placeholders = { NAME = "myFunction", PARAMS = "" },
		filetypes = { "javascript", "typescript" },
	},
	{
		name = "async function",
		template = [[
async function ${NAME}(${PARAMS}) {
${SELECTION}
}]],
		placeholders = { NAME = "myFunction", PARAMS = "" },
		filetypes = { "javascript", "typescript" },
	},
	{
		name = "function",
		template = [[
local function ${NAME}(${PARAMS})
${SELECTION}
end]],
		placeholders = { NAME = "my_function", PARAMS = "" },
		filetypes = { "lua" },
	},
	{
		name = "do-while",
		template = [[
do {
${SELECTION}
} while (${CONDITION});]],
		placeholders = { CONDITION = "condition" },
		filetypes = { "javascript", "typescript", "java", "c", "cpp", "scala" },
	},
	{
		name = "block",
		template = [[
{
${SELECTION}
}]],
		placeholders = {},
		filetypes = { "javascript", "typescript", "java", "c", "cpp", "rust", "go", "scala" },
	},
	{
		name = "match",
		template = [[
match ${VALUE} {
${SELECTION}
}]],
		placeholders = { VALUE = "value" },
		filetypes = { "rust" },
	},
	{
		name = "region",
		template = [[
// region ${NAME}
${SELECTION}
// endregion]],
		placeholders = { NAME = "Region" },
		filetypes = { "javascript", "typescript", "java", "c", "cpp", "rust", "go", "scala" },
	},
	-- Scala-specific templates
	{
		name = "for comprehension",
		template = [[
for {
${GENERATOR}
} yield ${SELECTION}]],
		placeholders = { GENERATOR = "x <- collection" },
		filetypes = { "scala" },
	},
	{
		name = "match",
		template = [[
${VALUE} match {
${SELECTION}
}]],
		placeholders = { VALUE = "value" },
		filetypes = { "scala" },
	},
	{
		name = "case class",
		template = [[
case class ${NAME}(${SELECTION})
]],
		placeholders = { NAME = "MyClass" },
		filetypes = { "scala" },
	},
	{
		name = "def",
		template = [[
def ${NAME}(${PARAMS}): ${RETURN_TYPE} = {
${SELECTION}
}]],
		placeholders = { NAME = "myMethod", PARAMS = "", RETURN_TYPE = "Unit" },
		filetypes = { "scala" },
	},
	{
		name = "object",
		template = [[
object ${NAME} {
${SELECTION}
}]],
		placeholders = { NAME = "MyObject" },
		filetypes = { "scala" },
	},
	{
		name = "trait",
		template = [[
trait ${NAME} {
${SELECTION}
}]],
		placeholders = { NAME = "MyTrait" },
		filetypes = { "scala" },
	},
	{
		name = "class",
		template = [[
class ${NAME}(${PARAMS}) {
${SELECTION}
}]],
		placeholders = { NAME = "MyClass", PARAMS = "" },
		filetypes = { "scala" },
	},
	{
		name = "Option.fold",
		template = [[
${VALUE}.fold(${DEFAULT}) { ${VAR} =>
${SELECTION}
}]],
		placeholders = { VALUE = "option", DEFAULT = "defaultValue", VAR = "value" },
		filetypes = { "scala" },
	},
	{
		name = "Either.fold",
		template = [[
${VALUE}.fold(
${LEFT} => ${LEFT_HANDLER},
${RIGHT} => {
${SELECTION}
}
)]],
		placeholders = { VALUE = "either", LEFT = "error", LEFT_HANDLER = "handleError(error)", RIGHT = "value" },
		filetypes = { "scala" },
	},
	{
		name = "Future",
		template = [[
Future {
${SELECTION}
}]],
		placeholders = {},
		filetypes = { "scala" },
	},
}

-- Get templates for current filetype
function M.get_templates_for_filetype(filetype)
	local templates = {}
	for _, template in ipairs(M.templates) do
		if vim.tbl_contains(template.filetypes, filetype) then
			table.insert(templates, template)
		end
	end
	return templates
end

return M
