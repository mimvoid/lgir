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

  local enum = { name = utils.get_nested(enumeration, "_attr", "name") }

  if enumeration.member == nil or enum.name == nil then
    return nil
  end

  enum.doc = utils.get_nested(enumeration, "doc", 1)
  enum.members = utils.filter_map(enumeration.member, function(member)
    if member._attr and member._attr.name and member._attr.value then
      return {
        name = member._attr.name,
        value = member._attr.value,
        doc = utils.get_nested(member, "doc", 1),
      }
    end
  end)

  return enum
end

---@param namespace table
---@return luals_gir.gir.enum[]? enums, luals_gir.gir.enum[]? bitfields
return function(namespace)
  local enums = nil
  local bitfields = nil

  if namespace.enumeration ~= nil then
    enums = utils.filter_map(namespace.enumeration, process_enum)
  end
  if namespace.bitfield ~= nil then
    bitfields = utils.filter_map(namespace.bitfield, process_enum)
  end

  return enums, bitfields
end
