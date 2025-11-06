local version = "0.1.0"
local help_str = [[
Usage: luals-gir [OPTIONS] [GIRS]...

Arguments:
  [GIRS]...     The GIR file(s) to search for

Options:
  --version     Print version
  --help, -h    Print help]]

---@class luals_gir.args
---@field girs string[]

---@return luals_gir.args
return function()
  local args = {
    girs = {},
  }

  for i, a in ipairs(arg) do
    if i ~= 0 then
      if a == "--help" or a == "-h" then
        print(help_str)
        os.exit(0)
      elseif a == "--version" then
        print(version)
        os.exit(0)
      elseif a[1] == "-" then
        print("Unknown option: " .. a)
        os.exit(1)
      end

      table.insert(args.girs, a)
    end
  end

  if #args.girs == 0 then
    print("No gir files provided!")
    os.exit(1)
  end

  return args
end
