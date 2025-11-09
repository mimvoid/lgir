local helpers = require("lgir.parse.helpers")

---@param constants table
---@return table<string, string>
return function(constants)
  local result = {}

  for i = 1, #constants do
    local constant = constants[i]
    local name = helpers.get_name(constant)
    local doc = helpers.get_doc(constant)

    if name and doc then
      result[name] = doc
    end
  end

  return result
end
