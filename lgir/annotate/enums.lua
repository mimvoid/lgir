local table, pairs = table, pairs
local helpers = require("lgir.annotate.helpers")

local M = {}

---lgi accepts enums (and bitfields) as both strings and numbers. This implementation
---accounts for that by creating a class for the enum keys and the enum as a whole.
---@param info table
---@param docs lgir.gir_docs.enum?
---@return string?
function M.alias(info, docs)
  local lines = { "" }
  if docs and docs.doc then
    table.insert(lines, helpers.format_doc(docs.doc))
  end

  table.insert(lines, ("---@alias %sKeys"):format(info._name))

  for member, _ in pairs(info) do
    if member:sub(1, 1) ~= "_" then
      local name = ([[---| '"%s"']]):format(member)
      local member_doc = docs ~= nil and helpers.inline_doc(name, docs.members[member], true, true) or name
      table.insert(lines, member_doc)
    end
  end

  table.insert(lines, ("---@alias %s %sKeys | integer"):format(info._name, info._name))
  return table.concat(lines, "\n")
end

---Creates a list of field annotations for enums. These should be top-level fields
---in the GI repository class.
---@param field_name string
---@param type_name string
---@return string
function M.field(field_name, type_name)
  return ("---@field %s table<%sKeys, integer>"):format(field_name, type_name)
end

---Writes type annotations for enums (or bitfields) and field annotations for the
---top-level repository class.
---@param enums table
---@param gir_enum_docs table<string, lgir.gir_docs.enum>
---@return string[]? aliases, string[]? fields
function M.list(enums, gir_enum_docs)
  if enums == nil or gir_enum_docs == nil then
    return nil
  end

  local alias_lines = {}
  local field_lines = {}

  for name, data in pairs(enums) do
    if name:sub(1, 1) ~= "_" then
      table.insert(alias_lines, M.alias(data, gir_enum_docs[name]))
      table.insert(field_lines, M.field(name, data._name))
    end
  end

  return alias_lines, field_lines
end

return M
