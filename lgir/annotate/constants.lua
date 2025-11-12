local pairs, type = pairs, type
local helpers = require("lgir.annotate.helpers")

local M = {}

---Simple field writer that considers if the docs table as a whole is nil
---@param name string
---@param value any
---@param docs? table<string, string>
function M.field(name, value, docs)
  local field = ("---@field %s %s"):format(name, type(value))
  return docs and helpers.inline_doc(field, docs[name]) or field
end

---Creates a list of field annotations for constants. These should be top-level fields
---in the GI repository class.
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
