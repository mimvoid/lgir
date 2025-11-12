local table, pairs, next, type = table, pairs, next, type
local helpers = require("lgir.annotate.helpers")
local funcs = require("lgir.annotate.functions")

local M = {}

---Formats a field of a struct.
---@param name string
---@param value any
---@param doc string?
---@return string
function M.field(name, value, doc)
  return helpers.inline_doc(("---@field %s %s"):format(name, type(value)), doc)
end

---Annotates a struct, including its fields, methods, and functions.
---@param name string
---@param struct table
---@param doc lgir.gir_docs.struct?
---@param inherits string[]?
---@return string repo_field, string[] class
function M.struct(name, struct, doc, inherits)
  local repo_field = ("---@field %s %s"):format(name, struct._name)

  local lines = {""}
  if doc and doc.doc then
    table.insert(lines, helpers.format_doc(doc.doc))
  end

  if inherits ~= nil and #inherits ~= 0 then
    table.insert(lines, ("---@class %s: %s"):format(struct._name, table.concat(inherits, ", ")))
  else
    table.insert(lines, "---@class " .. struct._name)
  end

  if struct._field ~= nil then
    for field, value in pairs(struct._field) do
      local field_doc = doc and doc.fields[field] and doc.fields[field].doc or nil
      table.insert(lines, M.field(field, value, field_doc))
    end
  end

  local has_functions = doc ~= nil and next(doc.functions) ~= nil
  local has_methods = doc ~= nil and next(doc.methods) ~= nil

  if has_functions or has_methods then
    table.insert(lines, ("local %s = {}"):format(name))
    if has_functions and doc ~= nil then
      table.insert(lines, table.concat(funcs.function_list(name, doc.functions), "\n"))
    end
    if has_methods and doc ~= nil then
      table.insert(lines, table.concat(funcs.function_list(name, doc.methods, nil, true), "\n"))
    end
  end

  return repo_field, lines
end

---Find the parent class and interface implementations, if available.
---This is mainly meant for classes and interfaces.
function M.find_inherits(gi_data)
  local result = {}

  if gi_data._parent then
    result[1] = gi_data._parent._name
  end
  if gi_data._implements then
    for _, iface in pairs(gi_data._implements) do
      table.insert(result, iface._name)
    end
  end

  return result
end

---Writes a list of structs (which can also be classes, unions, or interfaces).
---@param structs table<string, table>
---@param docs table<string, lgir.gir_docs.struct>
---@param check_inherits boolean?
---@return string[]? classes, string[]? repo_fields
function M.list(structs, docs, check_inherits)
  if structs == nil or docs == nil then
    return nil
  end

  local class_lines = {}
  local repo_field_lines = {}

  for name, struct in pairs(structs) do
    if name ~= "_namespace" and struct._name ~= nil then
      local inherits = check_inherits and M.find_inherits(struct) or nil

      local field, class = M.struct(name, struct, docs[name], inherits)
      table.insert(class_lines, table.concat(class, "\n"))
      table.insert(repo_field_lines, field)
    end
  end

  return class_lines, repo_field_lines
end

return M
