local string, table = string, table
local utils = require("luals-gir.utils")

---@param namespace luals_gir.gir.namespace
---@return string[]?
return function(namespace)
  if namespace.enumeration == nil then
    return nil
  end

  local name = namespace.name
  local lines = {}

  for i = 1, #namespace.enumeration do
    table.insert(lines, "")
    local enum = namespace.enumeration[i]

    if enum.doc ~= nil then
      local doc_lines = utils.split(enum.doc, "\n")
      for j = 1, #doc_lines do
        table.insert(lines, "---" .. doc_lines[j])
      end
    end

    table.insert(lines, string.format("---@class %s.%s", name, enum.name))

    for j = 1, #enum.members do
      local member = enum.members[j]
      local field = {
        "---@field",
        string.upper(member.name),
        tonumber(member.value) and "integer" or "unknown",
      }

      if member.doc ~= nil then
        local docstr, _ = member.doc:gsub("\n", "")
        table.insert(field, docstr)
      end

      table.insert(lines, table.concat(field, " "))
    end
  end

  return lines
end
