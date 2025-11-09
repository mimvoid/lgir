local helpers = require("lgir.annotate.helpers")

---@param constants table
---@param docs table<string, string>
---@return string[]
return function(constants, docs)
  local lines = {}

  for name, value in pairs(constants) do
    if name ~= "_namespace" then
      local field = {("---@field %s %s"):format(name, type(value))}

      if docs ~= nil and docs[name] ~= nil then
        field[2] = helpers.inline(docs[name])
      end

      table.insert(lines, table.concat(field, " "))
    end
  end

  return lines
end
