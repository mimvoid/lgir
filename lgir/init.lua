local paths = require("lgir.paths")
local reader = require("lgir.reader")
local process = require("lgir.process")
local args = require("lgir.args")
local write = require("lgir.write")
local utils = require("lgir.utils")

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

  local gir_table = reader.parse_gir(file)
  local gir_data = process(gir_table)
  if gir_data == nil then
    print("Failed to parse GIR file " .. gir)
    os.exit(1)
  end

  write(string.format("%s/%s", parsed_args.output, lua), gir_data)
end
