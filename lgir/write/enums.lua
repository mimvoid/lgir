local string, table = string, table
local utils = require("lgir.utils")

local function write_enum(namespace_name, enum)
  local lines = {}

  if enum.doc ~= nil then
    local doc_lines = utils.split(enum.doc, "\n")
    for j = 1, #doc_lines do
      table.insert(lines, "---" .. doc_lines[j])
    end
  end

  table.insert(lines, string.format("---@class %s.%s", namespace_name, enum.name))

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

  return table.concat(lines, "\n")
end

local function write_enums(namespace_name, enums)
  local lines = utils.map(enums, function(enum)
    return "\n" .. write_enum(namespace_name, enum)
  end)

  return table.concat(lines, "\n")
end

---@param namespace lgir.gir.namespace
---@return string[]?
return function(namespace)
  local lines = {}

  if namespace.enumeration ~= nil then
    table.insert(lines, write_enums(namespace.name, namespace.enumeration))
  end
  if namespace.bitfield ~= nil then
    table.insert(lines, write_enums(namespace.name, namespace.bitfield))
  end

  return #lines ~= 0 and lines or nil
end
