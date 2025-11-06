local utils = require("luals-gir.utils")

local M = {}

---@param gir_filename string
---@return string
function M.process_gir_filename(gir_filename)
  local res = gir_filename

  if not utils.ends_with(gir_filename, ".gir") then
    res = res .. ".gir"
  end

  return res
end

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
