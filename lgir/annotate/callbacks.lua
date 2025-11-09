local table = table
local helpers = require("lgir.annotate.helpers")

---@param namespace string
---@param callback_docs table<string, lgir.gir_docs.func>
return function(namespace, callback_docs)
  local lines = {}

  for name, info in pairs(callback_docs) do
    table.insert(lines, "")
    if info.doc ~= nil then
      table.insert(lines, helpers.format_doc(info.doc))
    end

    local params = {}

    for param, param_info in pairs(info.params) do
      table.insert(params, ("%s: %s"):format(param, param_info.type))

      if param_info.doc ~= nil then
        local doc = helpers.inline(param_info.doc)
        table.insert(lines, ("---@param_ %s %s %s"):format(param, param_info.type, doc))
      end
    end

    if info.return_value.doc ~= nil then
      local doc = helpers.inline(info.return_value.doc)
      table.insert(lines, ("---@return_ %s result %s"):format(info.return_value.type, doc))
    end

    table.insert(
      lines,
      ("---@alias %s.%s fun(%s): %s"):format(namespace, name, table.concat(params, ", "), info.return_value.type)
    )
  end

  return lines
end
