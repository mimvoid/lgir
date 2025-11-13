local table = table
local utils = require("lgir.utils")

local M = {}

---Comments all lines except the first in a potentially multiline documentation.
function M.reflow(doc)
  return doc:gsub("\n", "\n---")
end

---Comments a potentially multiline documentation.
---@param doc string
---@return string
function M.format_doc(doc)
  return "---" .. M.reflow(doc)
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
---@param reflow boolean? Allow multiline docs to wrap over
---@param with_comment boolean?
---@return string
function M.inline_doc(type_annotation, doc, reflow, with_comment)
  if doc == nil then
    return type_annotation
  end

  local result = { type_annotation }
  if with_comment then
    result[2] = "#"
  end

  local doc_annotations = reflow and M.reflow(doc) or M.inline(doc)
  table.insert(result, doc_annotations)

  return table.concat(result, " ")
end

return M
