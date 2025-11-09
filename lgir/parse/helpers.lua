local utils = require("lgir.utils")

local M = {}

---@param tabl table
---@return string? name
function M.get_name(tabl)
  return utils.get_nested(tabl, "_attr", "name")
end

---@param tabl table
---@return string? doc
function M.get_doc(tabl)
  return utils.get_nested(tabl, "doc", 1)
end

return M
