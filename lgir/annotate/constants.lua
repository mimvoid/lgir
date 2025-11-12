local helpers = require("lgir.annotate.helpers")

local M = {}

function M.field(name, value, docs)
  local field = ("---@field %s %s"):format(name, type(value))
  return docs and helpers.inline_doc(field, docs[name]) or field
end

---@param constants table
---@param docs table<string, string>
---@return string[]
function M.list(constants, docs)
  local lines = {}
  for name, value in pairs(constants) do
    if name ~= "_namespace" then
      table.insert(lines, M.field(name, value, docs))
    end
  end
  return lines
end

return M
