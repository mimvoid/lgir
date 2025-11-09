local M = {}

---@param doc string
---@return string
function M.format_doc(doc)
  return "---" .. doc:gsub("\n", "\n---")
end

---@param str string
---@return string
function M.inline(str)
  local result, _ = str:gsub("\n", "")
  return result
end

---@param type_annotation string
---@param doc string?
function M.inline_doc(type_annotation, doc)
  if doc == nil then
    return type_annotation
  end
  return ("%s %s"):format(type_annotation, M.inline(doc))
end

return M
