local table, pairs = table, pairs
local utils = require("lgir.utils")
local helpers = require("lgir.annotate.helpers")

local M = {}

---@param param lgir.gir_docs.param
---@param for_callback? boolean
---@return string
function M.param(param, for_callback)
  local template = for_callback and "---@param_ %s %s" or "---@param %s %s"
  return helpers.inline_doc(template:format(param.name, param.type), param.doc)
end

---@param params lgir.gir_docs.param[]
---@param for_callback boolean?
---@return string[] param_names, string[] param_lines
function M.param_list(params, for_callback)
  local names = {}
  local lines = {}

  for i = 1, #params do
    local param = params[i]
    table.insert(names, param.name)
    table.insert(lines, M.param(param, for_callback))
  end

  return names, lines
end

---@param value { type: string, doc: string? }
---@return string
function M.return_value(value)
  return helpers.inline_doc("---@return " .. value.type, value.doc, true)
end

---@param params lgir.gir_docs.param[]
---@return string[] lines
function M.out_params(params)
  return utils.map(params, function(out)
    return helpers.inline_doc(("---@return %s %s"):format(out.type, out.name), out.doc)
  end)
end

---@param class string
---@param name string
---@param docs lgir.gir_docs.func
---@param as_method? boolean
function M.func(class, name, docs, as_method)
  local lines = { "" }
  if docs.doc ~= nil then
    lines[2] = helpers.format_doc(docs.doc)
  end

  local param_names, param_lines = M.param_list(docs.params)
  if #param_lines ~= 0 then
    table.insert(lines, table.concat(param_lines, "\n"))
  end

  table.insert(lines, M.return_value(docs.return_value))
  if #docs.out_params ~= 0 then
    table.insert(lines, table.concat(M.out_params(docs.out_params), "\n"))
  end

  local sig_template = as_method and "function %s:%s(%s) end" or "function %s.%s(%s) end"
  local sig = sig_template:format(class, name, table.concat(param_names, ", "))
  table.insert(lines, sig)

  return table.concat(lines, "\n")
end

---@param class string
---@param func_docs table<string, lgir.gir_docs.func>
---@param functions string[]?
---@param as_methods? boolean
---@return string[]
function M.function_list(class, func_docs, functions, as_methods)
  if functions == nil then
    local result = {}
    for name, docs in pairs(func_docs) do
      table.insert(result, M.func(class, name, docs, as_methods))
    end
    return result
  end

  return utils.filter_map(functions, function(func_name)
    local docs = func_docs[func_name]
    if docs ~= nil then
      return M.func(class, func_name, docs, as_methods)
    end
  end)
end

---@param namespace string
---@param name string
---@param docs lgir.gir_docs.func
function M.callback(namespace, name, docs)
  local lines = { "" }
  if docs.doc ~= nil then
    lines[2] = helpers.format_doc(docs.doc)
  end

  local param_names, param_lines = M.param_list(docs.params, true)
  if #param_lines ~= 0 then
    table.insert(lines, table.concat(param_lines, "\n"))
  end

  -- The return type is also in the function signature, so only write an annotation if documentation exists
  if docs.return_value.doc then
    table.insert(lines, M.return_value(docs.return_value))
  end
  if #docs.out_params ~= 0 then
    table.insert(lines, table.concat(M.out_params(docs.out_params), "\n"))
  end

  local sig = "---@alias %s.%s fun(%s): %s"
  table.insert(lines, sig:format(namespace, name, table.concat(param_names, ", "), docs.return_value.type))

  return lines
end

---@param namespace string
---@param callbacks table<string, lgir.gir_docs.func>
---@return string[]
function M.callback_list(namespace, callbacks)
  local result = {}
  for name, callback in pairs(callbacks) do
    table.insert(result, table.concat(M.callback(namespace, name, callback), "\n"))
  end
  return result
end

return M
