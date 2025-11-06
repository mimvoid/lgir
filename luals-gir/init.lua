local paths = require("luals-gir.paths.init")
local reader = require("luals-gir.reader.init")
local utils = require("luals-gir.utils")
local args = require("luals-gir.args")
local inspect = require("inspect")

local parsed_args = args()
local girs = utils.map(parsed_args.girs, paths.process_gir_filename)

local gir_dirs = paths.gir_dirs()
if gir_dirs == nil then
  error("Could not find GIR directories")
  os.exit(1)
end

for _, filename in ipairs(girs) do
  local file = reader.find_gir_file(filename, gir_dirs)
  if file == nil then
    print("Could not find GIR file " .. filename)
    os.exit(1)
  end

  local xml = reader.load_gir(file)
  if xml == nil then
    print("Hm, " .. filename .. " doesn't seem to be a valid GIR file")
    os.exit(1)
  end

  print(inspect(xml))
end
