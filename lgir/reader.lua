local io = io
local xml2lua = require("xml2lua")
local handler = require("xmlhandler.tree")

local M = {}

---@param gir_filename string
---@param dirs string[]
---@return file*? file, string? path
function M.find_gir_file(gir_filename, dirs)
  -- TODO: allow searching by packages

  for i = 1, #dirs do
    local gir_path = dirs[i] .. "/" .. gir_filename
    local file = io.open(gir_path)

    if file ~= nil then
      return file, gir_path
    end
  end
end

---@param gir_file file*
---@return table
function M.parse_gir(gir_file)
  local contents = gir_file:read("*a")
  gir_file:close()

  local gir_handler = handler:new()

  -- Don't reduce children vectors of these tags, even with one child
  local noreduce_tags = {
    "enumeration",
    "bitfield",
    "record",
    "class",
    "callback",
    "function",
    "parameter",
    "include",
    "field",
    "member",
  }
  for i = 1, #noreduce_tags do
    gir_handler.options.noreduce[noreduce_tags[i]] = true
  end

  local parser = xml2lua.parser(gir_handler)
  parser:parse(contents)

  return gir_handler.root
end

return M
