local helpers = require("lgir.parse.helpers")

---Information lgir stores for an enum, independent of lgi's introspection.
---This is mainly documentation strings since enums are simple and most information is
---findable with lgi.
---@class lgir.gir_docs.enum
---@field doc string?
---@field members table<string, string>

local M = {}

---Parses enum information from a table, returning values if the input is well-formed.
---@param enum table
---@return string? name, lgir.gir_docs.enum?
function M.enum(enum)
  local name = helpers.get_name(enum)
  if name == nil then
    return nil
  end

  local docs = {
    doc = helpers.get_doc(enum),
    members = {}
  }

  for i = 1, #enum.member do
    local member_name, member_doc = helpers.get_name_doc(enum.member[i])
    if member_name then
      docs.members[member_name:upper()] = member_doc
    end
  end

  return name, docs
end

---Searches through an array and returns any successfully parsed enums.
---@param enums table[]
---@return table<string, lgir.gir_docs.enum>
function M.list(enums)
  local result = {}

  for i = 1, #enums do
    local name, enum = M.enum(enums[i])
    if name and enum then
      result[name] = enum
    end
  end

  return result
end

return M
