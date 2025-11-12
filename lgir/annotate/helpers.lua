local table = table
local utils = require("lgir.utils")

local M = {}

---Formats a potentially multiline documentation to ensure it is properly commented.
---@param doc string
---@return string
function M.format_doc(doc)
  return "---" .. doc:gsub("\n", "\n---")
end

---Removes all new line ("\n") characters, trims any leading or trailing whitespace
---on each line, and joins them into a single line string.
---@param str string
---@return string
function M.inline(str)
  local lines = utils.collect(utils.map(utils.split(str, "\n"), utils.strip))
  return table.concat(lines, " ")
end

---Appends an inline documentation, if available, to a type annotation.
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
