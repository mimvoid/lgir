local helpers = require("lgir.parse.helpers")

---@alias lgir.gir_docs.param { name: string, type: string, doc: string? }

---@class lgir.gir_docs.func
---@field doc? string
---@field return_value { type: string, doc: string? }
---@field params lgir.gir_docs.param[]
---@field out_params lgir.gir_docs.param[]

---@param param table
---@return lgir.gir_docs.param? info, boolean? out
local function parse_param(param)
  local result = { type = helpers.get_type(param) }
  if not result.type then
    return nil
  end

  result.name = helpers.get_name(param)
  if not result.name then
    return nil
  end

  result.doc = helpers.get_doc(param)

  local out = param._attr.direction == "out"
  return result, out
end

---@param return_value table
---@return { type: string, doc: string? }?
local function parse_return_value(return_value)
  local type_name = helpers.get_type(return_value)
  if type_name ~= nil then
    return { type = type_name, doc = helpers.get_doc(return_value) }
  end
end

---@param func table
---@return string? name, lgir.gir_docs.func? result
local function parse_function(func)
  local name = helpers.get_name(func)
  local return_val = func["return-value"]

  if name == nil or return_val == nil then
    return nil
  end

  local result = {
    doc = helpers.get_doc(func),
    return_value = parse_return_value(return_val),
    params = {},
    out_params = {},
  }
  if not result.return_value then
    return nil
  end

  if func.parameters and func.parameters.parameter then
    for i = 1, #func.parameters.parameter do
      local param, out = parse_param(func.parameters.parameter[i])
      if param then
        table.insert(out and result.out_params or result.params, param)
      end
    end
  end

  return name, result
end

---@param functions table[]
---@return table<string, lgir.gir_docs.func>
return function(functions)
  local result = {}

  for i = 1, #functions do
    local name, func = parse_function(functions[i])
    if name and func then
      result[name] = func
    end
  end

  return result
end
