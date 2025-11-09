local helpers = require("lgir.parse.helpers")

---@class lgir.gir_docs.enum
---@field doc string?
---@field members table<string, string>

---@param enums table
---@return table<string, lgir.gir_docs.enum>
return function(enums)
  local result = {}

  for i = 1, #enums do
    local enum = enums[i]
    local name = helpers.get_name(enum)
    if name ~= nil then
      local enum_docs = {
        doc = helpers.get_doc(enum),
        members = {}
      }

      for j = 1, #enum.member do
        local member = enum.member[j]
        local member_name = helpers.get_name(member)
        if member_name then
          enum_docs.members[member_name:upper()] = helpers.get_doc(member)
        end
      end

      result[name] = enum_docs
    end
  end

  return result
end
