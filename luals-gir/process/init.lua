local table = table
local process_enums = require('luals-gir.process.enums')
local utils = require("luals-gir.utils")

---@class luals_gir.gir.namespace
---@field name string
---@field version string
---@field bitfield? table[]
---@field enumeration? luals_gir.gir.enum[]
---@field record? table[]
---@field class? table[]
---@field callback? table[]
---@field functions? table[]

---@class luals_gir.gir
---@field namespace luals_gir.gir.namespace
---@field doc_format? string
---@field include { name: string, version: string }[]
---@field pkg? { name: string }

---Cleans the table parsed from XML. Removes things that cannot or should not
---be documented, or that are currently unimplemented.
---NOTE: currenty non-exhaustive
---@param gir_table table
---@return luals_gir.gir?
return function(gir_table)
  local repository = gir_table.repository
  local namespace = repository and repository.namespace

  if not repository or not namespace or not namespace._attr then
    return nil
  end
  if not namespace._attr.name or not namespace._attr.version then
    return nil
  end

  local res = {
    namespace = {
      name = namespace._attr.name,
      version = namespace._attr.version,
    },
    include = {},
    doc_format = utils.get_nested(repository, "doc:format", "_attr", "name"),
  }

  if repository.include ~= nil then
    for i = 1, #repository.include do
      local dep = utils.get_nested(repository.include, i, "_attr")
      if dep and dep.name and dep.version then
        table.insert(res.include, { name = dep.name, version = dep.version })
      end
    end
  end

  local pkg_name = utils.get_nested(repository, "package", "_attr", "name")
  if pkg_name then
    res.pkg = { name = pkg_name }
  end

  for _, tag in ipairs({ "bitfield", "record", "class", "callback" }) do
    res.namespace[tag] = namespace[tag]
  end
  res.namespace.enumeration = process_enums(namespace)
  res.namespace.functions = namespace["function"]

  return res
end
