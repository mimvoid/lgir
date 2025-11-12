local utils = require("lgir.utils")

local M = {}

---Finds the basename of the given filename, adds a ".gir" suffix if needed, and
---names the Lua file the annotations would be written to.
---@param filename string
---@return string gir, string lua
function M.process_gir_filename(filename)
  local gir = filename
  local basename = utils.remove_suffix(filename, ".gir")

  if basename == nil then
    gir = gir .. ".gir"
    basename = filename
  end

  local lua = basename .. ".lua"
  return gir, lua
end

---Finds the possible directories a GIR file could be installed to.
---NOTE: this currently isn't very compatible across distros.
---@return string[]?
function M.gir_dirs()
  local datadirs_env = os.getenv("XDG_DATA_DIRS")
  if datadirs_env == nil then
    return nil
  end

  local datadirs = utils.split(datadirs_env, ":")
  return utils.map(datadirs, function(dir)
    return dir .. "/gir-1.0"
  end)
end

return M
