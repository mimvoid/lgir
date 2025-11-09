local arg = arg
local utils = require("lgir.utils")

local version = "0.1.0"
local help_str = [[
Usage: lgir [OPTIONS] [GIRS]...

Arguments:
  [GIRS]...     The GIR file(s) to search for

Options:
  --output, -o  Output directory
  --version     Print version
  --help, -h    Print help]]

local function parse_arg_value(i, long_arg, short_arg)
  local a = arg[i]

  local arg_name = long_arg
  local value = utils.remove_prefix(a, arg_name)
  local skip = 0

  if value == nil and short_arg ~= nil then
    arg_name = short_arg
    value = utils.remove_prefix(a, arg_name)
  end
  if value == nil then
    return nil, skip
  end

  if value == "" then
    local next_arg = arg[i + 1]
    if next_arg == nil or next_arg:sub(1, 1) == "-" then
      print("No value provided for " .. arg_name)
      os.exit(1)
    end

    value = next_arg
    skip = 1
  else
    value = value:sub(2) -- remove "=" prefix
  end

  return value, skip
end

---@class lgir.args
---@field girs string[]
---@field output string

---@return lgir.args
return function()
  local args = {
    girs = {},
  }

  local i = 1
  local len = #arg

  while i <= len do
    local a = arg[i]

    if a:sub(1, 1) ~= "-" then
      table.insert(args.girs, a)
    else
      if a == "--help" or a == "-h" then
        print(help_str)
        os.exit(0)
      elseif a == "--version" then
        print(version)
        os.exit(0)
      end

      local value, skip = parse_arg_value(i, "--output", "-o")
      if value ~= nil then
        args.output = value
        i = i + skip
      else
        print("Unknown option: " .. a)
        os.exit(1)
      end
    end

    i = i + 1
  end

  if args.output == nil then
    print("No output directory provided!")
    os.exit(1)
  elseif #args.girs == 0 then
    print("No gir files provided!")
    os.exit(1)
  end

  return args
end
