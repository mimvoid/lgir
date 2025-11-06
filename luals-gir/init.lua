local paths = require("luals-gir.paths.init")

local args = arg
local gir_filenames = {}

for i, a in ipairs(args) do
  if i ~= 0 then
    if a[1] == "-" then
      error("Command line flags have not been implemented yet!")
      os.exit(1)
    else
      table.insert(gir_filenames, paths.process_gir_filename(a))
    end
  end
end

if #gir_filenames == 0 then
  error("No gir files provided")
  os.exit(1)
end

local gir_dirs = paths.gir_dirs()
if gir_dirs == nil then
  error("Could not find GIR directories")
  os.exit(1)
end

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
