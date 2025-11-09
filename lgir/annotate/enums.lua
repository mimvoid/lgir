local string, table = string, table
local helpers = require("lgir.annotate.helpers")

---@param info table
---@param docs lgir.gir_docs.enum?
---@return string?
local function alias_enum(info, docs)
  local lines = { "" }

  if docs and docs.doc then
    table.insert(lines, helpers.format_doc(docs.doc))
  end

  table.insert(lines, ("---@alias %sKeys"):format(info._name))

  for member, _ in pairs(info) do
    if member:sub(1, 1) ~= "_" then
      local member_doc = ([[---| '"%s"']]):format(member)

      if docs and docs.members[member] ~= nil then
        member_doc = ("%s # %s"):format(member_doc, docs.members[member]:gsub("\n", ""))
      end

      table.insert(lines, member_doc)
    end
  end

  table.insert(lines, ("---@alias %s %sKeys | integer"):format(info._name, info._name))
  return table.concat(lines, "\n")
end

---@param enums table
---@param gir_enum_docs table<string, lgir.gir_docs.enum>
---@return string[]? aliases, string[]? fields
return function(enums, gir_enum_docs)
  if enums == nil or gir_enum_docs == nil then
    return nil, nil
  end

  local alias_lines = {}
  local field_lines = {}

  for name, data in pairs(enums) do
    if name:sub(1, 1) ~= "_" then
      table.insert(alias_lines, alias_enum(data, gir_enum_docs[name]))
      table.insert(field_lines, ("---@field %s table<%sKeys, integer>"):format(name, data._name))
    end
  end

  return alias_lines, field_lines
end
