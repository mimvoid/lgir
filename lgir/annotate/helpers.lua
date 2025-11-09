local M = {}

---@param doc string
---@return string
function M.format_doc(doc)
  return string.format("---%s", doc:gsub("\n", "\n---"))
end

---@param type_annotation string
---@param doc string?
function M.inline_doc(type_annotation, doc)
  if doc == nil then
    return type_annotation
  end
  return string.format("%s %s", type_annotation, doc:gsub("\n", ""))
end

return M
