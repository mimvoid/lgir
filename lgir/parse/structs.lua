local helpers = require("lgir.parse.helpers")
local funcs = require("lgir.parse.functions")
local fields = require("lgir.parse.fields")

---@class lgir.gir_docs.struct
---@field doc string?
---@field fields table<string, lgir.gir_docs.field>
---@field functions table<string, lgir.gir_docs.func>
---@field methods table<string, lgir.gir_docs.func>

local M = {}

---Parses a single struct, which is called a record in GIR XML.
---@param record table
---@return string? name, lgir.gir_docs.struct? struct
function M.struct(record)
  local name = helpers.get_name(record)
  if name == nil then
    return nil
  end

  local result = {
    doc = helpers.get_doc(record),
    fields = record.field ~= nil and fields.list(record.field) or {},
    functions = record["function"] ~= nil and funcs.list(record["function"]) or {},
    methods = record.method ~= nil and funcs.list(record.method) or {},
  }

  return name, result
end

---Searches through an array and returns any successfully parsed structs.
---Note that structs are represented by the `record` tag in GIR XML.
---@param records table
---@return table<string, lgir.gir_docs.struct>
function M.list(records)
  local result = {}

  for i = 1, #records do
    local name, record = M.struct(records[i])
    if name and record then
      result[name] = record
    end
  end

  return result
end

return M
