local table = table
local helpers = require("lgir.annotate.helpers")

---@param namespace string
---@param functions table
---@param func_docs table<string, lgir.gir_docs.func>
---@return string[]
return function(namespace, functions, func_docs)
  local lines = {}

  for name, _ in pairs(functions) do
    local docs = func_docs[name]
    if docs ~= nil then
      table.insert(lines, "")
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

      local return_doc = helpers.inline_doc("---@return " .. docs.return_value.type, docs.return_value.doc)
      table.insert(lines, return_doc)

      local sig = ("function %s.%s(%s) end"):format(namespace, name, table.concat(param_names, ", "))
      table.insert(lines, sig)
    end
  end

  return lines
end
