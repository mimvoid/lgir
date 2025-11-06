local paths = require("luals-gir.paths.init")
local reader = require("luals-gir.reader.init")
local utils = require("luals-gir.utils")
local args = require("luals-gir.args")
local write = require("luals-gir.write.init")

local parsed_args = args()
local filename_pairs = utils.map(parsed_args.girs, paths.process_gir_filename)

local gir_dirs = paths.gir_dirs()
if gir_dirs == nil then
  error("Could not find GIR directories")
  os.exit(1)
end

for i = 1, #filename_pairs do
  local gir, lua = filename_pairs[i].gir, filename_pairs[i].lua

  local file = reader.find_gir_file(gir, gir_dirs)
  if file == nil then
    print("Could not find GIR file " .. gir)
    os.exit(1)
  end

  local gir_table = reader.load_gir(file)
  if gir_table == nil then
    print("Hm, " .. gir .. " doesn't seem to be a valid GIR file")
    os.exit(1)
  end

  write(string.format("%s/%s", parsed_args.output, lua), gir_table)
end
