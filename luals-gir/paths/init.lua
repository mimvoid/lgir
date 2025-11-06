local utils = require("luals-gir.utils")

local M = {}

---@return string[]?
M.gir_dirs = function()
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
