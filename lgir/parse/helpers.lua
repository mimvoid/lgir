local table = table
local gtypes = require("lgir.parse.gtypes")
local utils = require("lgir.utils")

local M = {}

local keywords = utils.set({
  "true",
  "false",
  "and",
  "or",
  "not",
  "nil",
  "local",
  "function",
  "return",
  "for",
  "do",
  "end",
  "break",
  "in",
  "if",
  "elseif",
  "else",
  "then",
  "while",
  "repeat",
  "until",
})

---Checks if the given string is a reserved Lua keyword, meaning it cannot be used as an indentifier
---for variables, function parameters, etc.
---
---If it is, prepends an underscore to fix the conflict. Otherwise, returns the string as-is.
---@param name string
---@return string
function M.fix_keyword(name)
  return keywords[name] == nil and name or "_" .. name
end

---Searches for the name attribute and fixes any conflicts with Lua keywords.
---@param tabl table
---@return string? name
function M.get_name(tabl)
  local name = utils.get_nested(tabl, "_attr", "name")
  if name ~= nil then
    return M.fix_keyword(name)
  end
end

---Searches for the documentation text.
---@param tabl table
---@return string? doc
function M.get_doc(tabl)
  return utils.get_nested(tabl, "doc", 1)
end

---Get the name and documentation at once.
---@param tabl table
---@return string? name, string? doc
function M.get_name_doc(tabl)
  return M.get_name(tabl), M.get_doc(tabl)
end

---Maps an array and returns all items' names as keys and documentation as values.
---@param list table[]
---@return table<string, string>
function M.filter_map_name_doc(list)
  local result = {}

  for i = 1, #list do
    local name, doc = M.get_name_doc(list[i])
    if name and doc then
      result[name] = doc
    end
  end

  return result
end

---Parses the type from GIR and formats it into a Lua-friendly type.
---@param tabl table
---@return string? type
function M.get_type(tabl)
  local is_array = tabl.array ~= nil
  local type_name = utils.get_nested(is_array and tabl.array or tabl, "type", "_attr", "name") or "unknown"

  local type_parts = { gtypes[type_name] or type_name }
  if is_array then
    table.insert(type_parts, "[]")
  end
  if tabl.nullable == "1" or tabl["allow-none"] == "1" then
    table.insert(type_parts, "?")
  end

  return table.concat(type_parts)
end

return M
