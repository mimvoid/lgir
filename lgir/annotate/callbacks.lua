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
    for i = 1, #info.params do
      local param = info.params[i]
      table.insert(params, ("%s: %s"):format(param.name, param.type))

      if param.doc ~= nil then
        local doc = helpers.inline(param.doc)
        table.insert(lines, ("---@param_ %s %s %s"):format(param.name, param.type, doc))
      end
    end

    -- The return type is also in the function signature, so only write an annotation if documentation exists
    if info.return_value.doc then
      table.insert(lines, ("---@return %s # %s"):format(info.return_value.type, helpers.inline(info.return_value.doc)))
    end

    for i = 1, #info.out_params do
      local out = info.out_params[i]
      table.insert(lines, helpers.inline_doc(("---@return %s %s"):format(out.type, out.name), out.doc))
    end

    table.insert(
      lines,
      ("---@alias %s.%s fun(%s): %s"):format(namespace, name, table.concat(params, ", "), info.return_value.type)
    )
  end

  return lines
end
