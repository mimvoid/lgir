local utils = require("lgir.utils")
local helpers = require("lgir.parse.helpers")
local gtypes = require("lgir.parse.gtypes")

---@class lgir.gir_docs.func
---@field doc? string
---@field return_value { type: string, doc: string? }
---@field params table<string, { type: string, doc: string? }>

-- FIX: these parameters are not in order
local function process_param(param)
  local name = helpers.get_name(param)
  local param_type = utils.get_nested(param, "type", "_attr", "name")

  if not name or not param_type then
    return nil
  end

  -- Change parameter names that are Lua keywords
  if name == "function" then
    name = "func"
  end

  local result = {
    type = gtypes[param_type] or param_type,
    doc = helpers.get_doc(param),
  }

  if param.nullable == "1" or param["allow-none"] == "1" then
    result.type = result.type .. "?"
  end

  return name, result
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

  return { type = lua_type, doc = helpers.get_doc(return_value) }
end

local function process_function(func)
  local name = helpers.get_name(func)
  local return_val = func["return-value"]

  if name == nil or return_val == nil then
    return nil
  end

  local result = {
    doc = helpers.get_doc(func),
    return_value = parse_return_value(return_val),
    params = {},
  }
  if not result.return_value then
    return nil
  end

  if func.parameters and func.parameters.parameter then
    for i = 1, #func.parameters.parameter do
      local param_name, param = process_param(func.parameters.parameter[i])

      if param_name and param then
        result.params[param_name] = param
      end
    end
  end

  return name, result
end

return function(functions)
  local result = {}

  for i = 1, #functions do
    local name, func = process_function(functions[i])
    if name and func then
      result[name] = func
    end
  end

  return result
end
