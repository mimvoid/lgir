local table = table
local helpers = require("lgir.annotate.helpers")
local write_functions = require("lgir.annotate.functions")

---@param structs table<string, table>
---@param docs table<string, lgir.gir_docs.struct>
---@return string[]? classes, string[]? module_fields
return function(structs, docs)
  if structs == nil or docs == nil then
    return nil, nil
  end

  local class_lines = {}
  local module_field_lines = {}

  for name, struct in pairs(structs) do
    if name ~= "_namespace" then
      table.insert(class_lines, "\n---@class " .. struct._name)
      table.insert(module_field_lines, ("---@field %s %s"):format(name, struct._name))

      local doc = docs[name]
      if doc and doc.doc then
        table.insert(class_lines, helpers.format_doc(doc.doc))
      end

      if struct._field ~= nil then
        for field, value in pairs(struct._field) do
          local field_doc = doc.fields[field] and doc.fields[field].doc or nil
          table.insert(class_lines, helpers.inline_doc(("---@field %s %s"):format(field, type(value)), field_doc))
        end
      end

      local has_functions = next(doc.functions) ~= nil
      local has_methods = next(doc.methods) ~= nil

      if has_functions or has_methods then
        table.insert(class_lines, ("local %s = {}\n"):format(name))
        if has_functions then
          table.insert(class_lines, table.concat(write_functions(name, doc.functions), "\n"))
        end
        if has_methods then
          table.insert(class_lines, table.concat(write_functions(name, doc.methods, nil, true), "\n"))
        end
      end
    end
  end

  return class_lines, module_field_lines
end
