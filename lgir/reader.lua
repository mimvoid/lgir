local io = io
local xml2lua = require("xml2lua")
local handler = require("xmlhandler.tree")

local M = {}

---Searches through all provided directories for the given file, and returns the first found.
---This assumes a UNIX-like system with "/" path separators.
---@param filename string
---@param dirs string[]
---@return file*? file, string? path
function M.find_file(filename, dirs)
  for i = 1, #dirs do
    local path = ("%s/%s"):format(dirs[i], filename)
    local file = io.open(path)

    if file ~= nil then
      return file, path
    end
  end
end

---Reads the GIR file and parses it into a Lua table.
---@param gir_file file*
---@return table
function M.parse_gir_xml(gir_file)
  local contents = gir_file:read("*a")
  gir_file:close()

  local gir_handler = handler:new()

  -- Don't reduce children vectors of these tags, even with one child
  local noreduce_tags = {
    "enumeration",
    "bitfield",
    "record",
    "union",
    "class",
    "interface",
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
