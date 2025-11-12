local table = table
local helpers = require("lgir.annotate.helpers")
local funcs = require("lgir.annotate.functions")

local M = {}

---@param name string
---@param value any
---@param doc string?
---@return string
function M.field(name, value, doc)
  return helpers.inline_doc(("---@field %s %s"):format(name, type(value)), doc)
end

---@param struct table
---@param doc lgir.gir_docs.struct
---@return string repo_field, string[] class
function M.struct(name, struct, doc)
  local repo_field = ("---@field %s %s"):format(name, struct._name)

  local lines = {""}
  if doc.doc then
    table.insert(lines, helpers.format_doc(doc.doc))
  end

  table.insert(lines, "---@class " .. struct._name)

  if struct._field ~= nil then
    for field, value in pairs(struct._field) do
      local field_doc = doc.fields[field] and doc.fields[field].doc or nil
      table.insert(lines, M.field(field, value, field_doc))
    end
  end

  local has_functions = next(doc.functions) ~= nil
  local has_methods = next(doc.methods) ~= nil

  if has_functions or has_methods then
    table.insert(lines, ("local %s = {}"):format(name))
    if has_functions then
      table.insert(lines, table.concat(funcs.function_list(name, doc.functions), "\n"))
    end
    if has_methods then
      table.insert(lines, table.concat(funcs.function_list(name, doc.methods, nil, true), "\n"))
    end
  end

  return repo_field, lines
end

---@param structs table<string, table>
---@param docs table<string, lgir.gir_docs.struct>
---@return string[]? classes, string[]? repo_fields
function M.list(structs, docs)
  if structs == nil or docs == nil then
    return nil
  end

  local class_lines = {}
  local repo_field_lines = {}

  for name, struct in pairs(structs) do
    if name ~= "_namespace" then
      local field, class = M.struct(name, struct, docs[name])
      table.insert(class_lines, table.concat(class, "\n"))
      table.insert(repo_field_lines, field)
    end
  end

  return class_lines, repo_field_lines
end

return M
