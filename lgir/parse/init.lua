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
---@field classes? table<string, lgir.gir_docs.struct>
---@field interfaces? table<string, lgir.gir_docs.struct>
---@field unions? table<string, lgir.gir_docs.struct>

---TODO: the program could keep trying to parse different files
local function err_parse_fail(path)
  print("Failed to parse GIR file at " .. path)
  os.exit(1)
end

---Tries to parse a raw Lua table generated from GIR XML into organized information.
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

  if namespace.constant then
    result.constants = helpers.filter_map_name_doc(namespace.constant)
    result.constants._namespace = nil -- Don't save lgi's recursed namespace table
  end
  if namespace.enumeration then
    result.enums = enums.list(namespace.enumeration)
  end
  if namespace.bitfield then
    result.bitfields = enums.list(namespace.bitfield)
  end
  if namespace["function"] then
    result.functions = funcs.list(namespace["function"])
  end
  if namespace.callback then
    result.callbacks = funcs.list(namespace.callback)
  end
  if namespace.record then
    result.structs = structs.list(namespace.record)
  end
  if namespace.union then
    result.unions = structs.list(namespace.union)
  end
  if namespace.interface then
    result.interfaces = structs.list(namespace.interface)
  end
  if namespace.class then
    result.classes = structs.list(namespace.class)
  end

  return result
end
