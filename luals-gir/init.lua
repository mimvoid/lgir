local utils = require("luals-gir.utils")

local args = arg
local gir_filenames = {}

for i, a in ipairs(args) do
  if i ~= 0 then
    if a[1] == "-" then
      error("Command line flags have not been implemented yet!")
      os.exit(1)
    else
      table.insert(gir_filenames, a)
    end
  end
end

if #gir_filenames == 0 then
  error("No gir files provided")
  os.exit(1)
end

-- TODO: verify that gir filenames are well-formed

local datadirs_env = os.getenv("XDG_DATA_DIRS")
if datadirs_env == nil then
  error("Could not find XDG_DATA_DIRS")
  os.exit(1)
end

local datadirs = utils.split(datadirs_env, ":")
local gir_dirs = utils.map(datadirs, function(dir)
  return dir .. "/gir-1.0"
end)

for _, filename in ipairs(gir_filenames) do
  -- TODO: filter by package name
  for _, dir in ipairs(gir_dirs) do
    local gir_path = dir .. "/" .. filename
    local file = io.open(gir_path)

    -- Basic functionality to print files
    if file ~= nil then
      print(file:read("*a"))
      file:close()
    end
  end
end
