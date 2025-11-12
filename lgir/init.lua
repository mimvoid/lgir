local paths = require("lgir.paths")
local reader = require("lgir.reader")
local args = require("lgir.args")
local parse = require("lgir.parse")
local annotate = require("lgir.annotate")

local parsed_args = args()

--- Find all directories a GIR file could be installed to
local gir_dirs = paths.gir_dirs()
if gir_dirs == nil then
  error("Could not find GIR directories")
  os.exit(1)
end

--- Find, parse, and write annotations for each input GIR
for i = 1, #parsed_args.girs do
  local gir, lua = paths.process_gir_filename(parsed_args.girs[i])
  local file, path = reader.find_file(gir, gir_dirs)

  if file == nil or path == nil then
    print("Could not find GIR file " .. gir)
    os.exit(1)
  end

  local gir_table = reader.parse_gir_xml(file) -- Load the GIR XML into a Lua table
  local gir_docs = parse(gir_table, path) -- Organize and keep the information we want
  annotate(gir_docs, ("%s/%s"):format(parsed_args.output, lua)) -- Write to the file
end
