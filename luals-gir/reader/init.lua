local io = io
local xml2lua = require("xml2lua")
local handler = require("xmlhandler.tree")

local M = {}

---@param gir_filename string
---@param dirs string[]
---@return file*?
function M.find_gir_file(gir_filename, dirs)
  -- TODO: allow searching by packages

  for i = 1, #dirs do
    local gir_path = dirs[i] .. "/" .. gir_filename
    local file = io.open(gir_path)

    if file ~= nil then
      return file
    end
  end
end

---NOTE: currenty non-exhaustive
---@param gir_table table
---@return boolean
local function is_valid_gir(gir_table)
  local repository = gir_table.repository
  return repository ~= nil and repository.namespace ~= nil
end

---@param gir_file file*
---@return table?
function M.load_gir(gir_file)
  local contents = gir_file:read("*a")
  gir_file:close()

  local gir_handler = handler:new()

  -- Don't reduce children vectors of these tags, even with one child
  for _, tag in ipairs({ "enumeration", "bitfield", "record", "class", "callback", "function" }) do
    gir_handler.options.noreduce[tag] = true
  end

  local parser = xml2lua.parser(gir_handler)
  parser:parse(contents)

  if is_valid_gir(gir_handler.root) then
    return gir_handler.root
  end
end

return M
