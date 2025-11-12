local enums = require("lgir.parse.enums")
local funcs = require("lgir.parse.functions")
local structs = require("lgir.parse.structs")
local helpers = require("lgir.parse.helpers")

---@class lgir.gir_docs
---@field name string
---@field version string
---@field constants? table<string, string>
---@field enums? table<string, lgir.gir_docs.enum>
---@field bitfields? table<string, lgir.gir_docs.enum>
---@field functions? table<string, lgir.gir_docs.func>
---@field callbacks? table<string, lgir.gir_docs.func>
---@field structs? table<string, lgir.gir_docs.struct>
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

  if namespace.constant ~= nil then
    result.constants = helpers.filter_map_name_doc(namespace.constant)
  end
  if namespace.enumeration ~= nil then
    result.enums = enums.list(namespace.enumeration)
  end
  if namespace.bitfield ~= nil then
    result.bitfields = enums.list(namespace.bitfield)
  end
  if namespace["function"] ~= nil then
    result.functions = funcs.list(namespace["function"])
  end
  if namespace.callback ~= nil then
    result.callbacks = funcs.list(namespace.callback)
  end
  if namespace.record ~= nil then
    result.structs = structs.list(namespace.record)
  end

  return result
end
