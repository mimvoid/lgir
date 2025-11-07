local table = table
local utils = require("luals-gir.utils")

---@class luals_gir.gir.enum_member
---@field name string
---@field value string
---@field doc? string

---@class luals_gir.gir.enum
---@field name string
---@field doc? string
---@field members luals_gir.gir.enum_member[]

---@param enumeration table?
---@return luals_gir.gir.enum?
local function process_enum(enumeration)
  if enumeration == nil then
    return nil
  end

  local members = enumeration.member
  local enum = {
    name = utils.get_nested(enumeration, "_attr", "name"),
    doc = utils.get_nested(enumeration, "doc", 1),
    members = {},
  }

  if members == nil or enum.name == nil then
    return nil
  end

  for i = 1, #members do
    local member = members[i]
    if member._attr and member._attr.name and member._attr.value then
      table.insert(enum.members, {
        name = member._attr.name,
        value = member._attr.value,
        doc = utils.get_nested(member, "doc", 1),
      })
    end
  end

  return enum
end

return function(namespace)
  if namespace.enumeration == nil then
    return nil
  end

  local res = {}

  for i = 1, #namespace.enumeration do
    local enum = process_enum(namespace.enumeration[i])
    if enum ~= nil then
      table.insert(res, enum)
    end
  end

  return res
end
