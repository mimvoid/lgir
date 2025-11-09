local utils = require("luals-gir.utils")
local gtypes = require("luals-gir.process.gtypes")

---@class luals_gir.gir.func
---@field name string
---@field return_value { type: string, doc: string? }
---@field params { name: string, type: string, doc: string? }[]
---@field doc? string

local function process_param(param)
  local param_type = utils.get_nested(param, "type", "_attr", "name")
  if not param_type then
    return nil
  end

  local result = {
    name = utils.get_nested(param, "_attr", "name"),
    type = gtypes[param_type] or param_type,
    doc = utils.get_nested(param, "doc", 1),
  }
  if not result.name then
    return nil
  end

  -- Change parameter names that are Lua keywords
  if result.name == "function" then
    result.name = "func"
  end

  if param.nullable == "1" or param["allow-none"] == "1" then
    result.type = result.type .. "?"
  end

  return result
end

local function parse_return_value(return_value)
  local is_array = false
  local type_name = utils.get_nested(return_value, "type", "_attr", "name")

  if type_name == nil then
    type_name = utils.get_nested(return_value, "array", "type", "_attr", "name")
    if type_name == nil then
      return nil
    end
    is_array = true
  end

  local lua_type = gtypes[type_name] or type_name
  if is_array then
    lua_type = lua_type .. "[]"
  end

  return { type = lua_type, doc = utils.get_nested(return_value, "doc", 1) }
end

local function process_function(func)
  local return_val = func["return-value"]
  if return_val == nil then
    return nil
  end

  local result = {
    name = utils.get_nested(func, "_attr", "name"),
    return_value = parse_return_value(return_val),
    params = {},
  }
  if not result.name or not result.return_value then
    return nil
  end

  result.doc = utils.get_nested(func, "doc", 1)

  if func.parameters and func.parameters.parameter then
    result.params = utils.filter_map(func.parameters.parameter, process_param)
  end

  return result
end

return function(namespace)
  if namespace["function"] ~= nil then
    return utils.filter_map(namespace["function"], process_function)
  end
end
