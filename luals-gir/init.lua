local paths = require("luals-gir.paths.init")
local utils = require("luals-gir.utils")
local args = require("luals-gir.args")

local parsed_args = args()
local girs = utils.map(parsed_args.girs, paths.process_gir_filename)

local gir_dirs = paths.gir_dirs()
if gir_dirs == nil then
  error("Could not find GIR directories")
  os.exit(1)
end

for _, filename in ipairs(girs) do
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
