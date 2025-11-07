local table = table

---@class luals_gir.gir_data.namespace
---@field name string
---@field version string
---@field bitfield? table[]
---@field enumeration? table[]
---@field record? table[]
---@field class? table[]
---@field callback? table[]
---@field functions? table[]

---@class luals_gir.gir_data
---@field namespace luals_gir.gir_data.namespace
---@field doc_format? string
---@field include { name: string, version: string }[]
---@field pkg? { name: string }

---Cleans the table parsed from XML. Removes things that cannot or should not
---be documented, or that are currently unimplemented.
---NOTE: currenty non-exhaustive
---@param gir_table table
---@return luals_gir.gir_data?
return function(gir_table)
  local repository = gir_table.repository
  local namespace = repository and repository.namespace

  if repository == nil or namespace == nil or namespace._attr == nil then
    return nil
  end

  local name, version = namespace._attr.name, namespace._attr.version
  if name == nil or version == nil then
    return nil
  end

  local res = {
    namespace = {
      name = name,
      version = version,
    },
    include = {},
  }

  local doc = repository["doc:format"]
  if doc ~= nil and doc._attr ~= nil and doc._attr.name ~= nil then
    res.doc_format = doc._attr.name
  end

  if repository.include ~= nil then
    for i = 1, #repository.include do
      local dep = repository.include[i]

      if dep and dep._attr and dep._attr.name and dep._attr.version then
        table.insert(res.include, { name = dep._attr.name, version = dep._attr.version })
      end
    end
  end

  local pkg = repository["package"]
  if pkg and pkg._attr and pkg._attr.name then
    res.pkg = { name = pkg._attr.name }
  end

  for _, tag in ipairs({ "enumeration", "bitfield", "record", "class", "callback" }) do
    res.namespace[tag] = namespace[tag]
  end
  res.namespace.functions = namespace["function"]

  return res
end
