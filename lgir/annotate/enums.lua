local string, table = string, table
local helpers = require("lgir.annotate.helpers")

---@param enums table
---@param gir_enum_docs table<string, lgir.gir_docs.enum>
---@return string[]
return function(enums, gir_enum_docs)
  local lines = {}

  for name, data in pairs(enums) do
    local docs = gir_enum_docs[name]

    if docs ~= nil then
      if docs.doc then
        table.insert(lines, helpers.format_doc(docs.doc))
      end

      table.insert(lines, string.format("---@class %s", data._name))

      for member, _ in pairs(data) do
        if member ~= "_name" then
          local member_doc = string.format("---@field %s integer", member)
          if docs.members[member] ~= nil then
            member_doc = string.format("%s %s", member_doc, docs.members[member]:gsub("\n", ""))
          end
          table.insert(lines, member_doc)
        end
      end
    end
  end

  return lines
end
