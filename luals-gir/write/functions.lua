local string, table = string, table
local utils = require("luals-gir.utils")

---@param func luals_gir.gir.func
local function write_func(func)
  local lines = {""}

  if func.doc then
    table.insert(lines, "---" .. func.doc:gsub("\n", "\n%-%-%-"))
  end

  for i = 1, #func.params do
    local param = func.params[i]
    local param_doc = string.format("---@param %s %s", param.name, param.type)

    if param.doc then
      local desc, _ = string.format(" %s", param.doc:gsub("\n", ""))
      param = param .. desc
    end

    table.insert(lines, param_doc)
  end

  table.insert(lines, string.format("---@return %s", func.return_value.type))

  local params = table.concat(
    utils.map(func.params, function(param)
      return param.name
    end),
    ", "
  )
  table.insert(lines, string.format("local function %s(%s) end", func.name, params))

  return table.concat(lines, "\n")
end

return function(namespace)
  if namespace.functions ~= nil then
    return utils.map(namespace.functions, write_func)
  end
end
