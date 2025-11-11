local table = table
local utils = require("lgir.utils")
local helpers = require("lgir.annotate.helpers")

---@param class string
---@param name string
---@param docs lgir.gir_docs.func
local function write_func(class, name, docs)
  local lines = { "" }

  if docs.doc ~= nil then
    table.insert(lines, helpers.format_doc(docs.doc))
  end

  local param_names = {}

  for i = 1, #docs.params do
    local param = docs.params[i]

    table.insert(param_names, param.name)
    local param_doc = helpers.inline_doc(("---@param %s %s"):format(param.name, param.type), param.doc)
    table.insert(lines, param_doc)
  end

  local return_parts = { "---@return", docs.return_value.type }
  if docs.return_value.doc then
    table.insert(return_parts, "#")
    table.insert(return_parts, helpers.inline(docs.return_value.doc))
  end
  table.insert(lines, table.concat(return_parts, " "))

  for i = 1, #docs.out_params do
    local out = docs.out_params[i]
    table.insert(lines, helpers.inline_doc(("---@return %s %s"):format(out.type, out.name), out.doc))
  end

  local sig = ("function %s.%s(%s) end"):format(class, name, table.concat(param_names, ", "))
  table.insert(lines, sig)

  return table.concat(lines, "\n")
end

---@param class string
---@param func_docs table<string, lgir.gir_docs.func>
---@param functions string[]?
---@return string[]
return function(class, func_docs, functions)
  if functions == nil then
    local result = {}
    for name, docs in pairs(func_docs) do
      table.insert(result, write_func(class, name, docs))
    end
    return result
  end

  return utils.filter_map(functions, function(func_name)
    local docs = func_docs[func_name]
    if docs ~= nil then
      return write_func(class, func_name, docs)
    end
  end)
end
