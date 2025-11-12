local helpers = require("lgir.parse.helpers")

---@class lgir.gir_docs.field
---@field doc string?
---@field writable boolean
---@field type string

local M = {}

---Tries to parse a field from a table, returning values if successful.
---@param field table
---@return string? name, lgir.gir_docs.field? field
function M.field(field)
  local name = helpers.get_name(field)
  if not name then
    return nil
  end

  local field_docs = {
    doc = helpers.get_doc(field),
    writable = field._attr and field._attr.writable == "1",
    type = helpers.get_type(field),
  }

  if field_docs.type ~= nil then
    return name, field_docs
  end
end

---Searches through an array and returns any successfully parsed fields.
---@param fields table[]
---@return table<string, lgir.gir_docs.field>
function M.list(fields)
  local result = {}

  for i = 1, #fields do
    local name, field = M.field(fields[i])
    if name ~= nil and field ~= nil then
      result[name] = field
    end
  end

  return result
end

return M
