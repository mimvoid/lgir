local paths = require("lgir.paths")
local reader = require("lgir.reader")
local args = require("lgir.args")
local parse = require("lgir.parse")
local annotate = require("lgir.annotate")

local parsed_args = args()

local gir_dirs = paths.gir_dirs()
if gir_dirs == nil then
  error("Could not find GIR directories")
  os.exit(1)
end

for i = 1, #parsed_args.girs do
  local gir, lua = paths.process_gir_filename(parsed_args.girs[i])
  local file, path = reader.find_gir_file(gir, gir_dirs)

  if file == nil or path == nil then
    print("Could not find GIR file " .. gir)
    os.exit(1)
  end

  local gir_table = reader.parse_gir(file)
  local gir_docs = parse(gir_table, path)
  annotate(gir_docs, ("%s/%s"):format(parsed_args.output, lua))
end
