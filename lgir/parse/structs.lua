local helpers = require("lgir.parse.helpers")
local functions = require("lgir.parse.functions")

---@class lgir.gir_docs.field
---@field doc string?
---@field writable boolean
---@field type string

---@class lgir.gir_docs.struct
---@field doc string?
---@field fields table<string, lgir.gir_docs.field>
---@field functions table<string, lgir.gir_docs.func>

---@param record table
---@return string? name, lgir.gir_docs.struct? struct
local function parse_record(record)
  local name = helpers.get_name(record)
  if name == nil then
    return nil
  end

  local result = {
    doc = helpers.get_doc(record),
    fields = {},
    functions = record["function"] ~= nil and functions(record["function"]) or {},
  }

  if record.field ~= nil then
    for i = 1, #record.field do
      local field = record.field[i]
      local field_docs = {
        doc = helpers.get_doc(field),
        writable = field._attr and field._attr.writable == "1",
        type = helpers.get_type(field),
      }
      if field_docs.type ~= nil then
        table.insert(result.fields, field_docs)
      end
    end
  end

  return name, result
end

---Note: GIR files seem to call structs records
---@param records table
---@return table<string, lgir.gir_docs.struct>
return function(records)
  local result = {}

  for i = 1, #records do
    if records[i] ~= nil then
      local name, record = parse_record(records[i])
      if name and record then
        result[name] = record
      end
    end
  end

  return result
end
