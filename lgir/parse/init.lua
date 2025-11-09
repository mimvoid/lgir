local parse_enums = require("lgir.parse.enums")
local parse_functions = require("lgir.parse.functions")

---@class lgir.gir_docs
---@field name string
---@field version string
---@field enums? table
---@field bitfields? table
---@field functions? table
---@field callbacks? table
---@field structs? table
---@field classes? table

local function err_parse_fail(path)
  print("Failed to parse GIR file at " .. path)
  os.exit(1)
end

---@param gir_table table
---@param path string
---@return lgir.gir_docs
return function(gir_table, path)
  local root = gir_table.repository
  if not root then
    err_parse_fail(path)
  end

  local namespace = root.namespace
  if not namespace or not namespace._attr then
    err_parse_fail(path)
  end

  local result = { name = namespace._attr.name, version = namespace._attr.version }
  if not result.name or not result.version then
    err_parse_fail(path)
  end

  if namespace.enumeration ~= nil then
    result.enums = parse_enums(namespace.enumeration)
  end
  if namespace.bitfield ~= nil then
    result.bitfields = parse_enums(namespace.bitfield)
  end
  if namespace["function"] ~= nil then
    result.functions = parse_functions(namespace["function"])
  end

  return result
end
