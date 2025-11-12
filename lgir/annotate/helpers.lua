local table = table
local utils = require("lgir.utils")

local M = {}

---@param doc string
---@return string
function M.format_doc(doc)
  return "---" .. doc:gsub("\n", "\n---")
end

---@param str string
---@return string
function M.inline(str)
  local lines = utils.map(utils.split(str, "\n"), utils.strip)
  return table.concat(lines, " ")
end

---@param type_annotation string
---@param doc string?
---@param with_comment boolean?
---@return string
function M.inline_doc(type_annotation, doc, with_comment)
  local result = {type_annotation}

  if doc ~= nil then
    if with_comment then
      result[2] = "#"
    end
    table.insert(result, M.inline(doc))
  end

  return table.concat(result, " ")
end

return M
