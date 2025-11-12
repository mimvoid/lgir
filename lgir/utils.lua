local table, next, select = table, next, select
local M = {}

---Split a string by a separator
---@param str string The string to split
---@param sep string? The separator, "%s" by default
---@return string[]
function M.split(str, sep)
  if sep == nil then
    sep = "%s" -- Default to a space for the separator
  end

  local split_strs = {}

  for s in str:gmatch(("([^%s]+)"):format(sep)) do
    table.insert(split_strs, s)
  end

  return split_strs
end

---Trim any leading and trailing whitespaces from a string.
---@param str string The string to trim
---@return string # The trimmed string
function M.strip(str)
  return str:match("^%s*(.-)%s*$")
end

---Checks if a string starts with a given prefix.
---@param str string
---@param prefix string
---@return boolean
function M.starts_with(str, prefix)
  return str:sub(1, prefix:len()) == prefix
end

---Checks if a string starts with a given prefix, and if it does, returns a substring
---without the prefix. Otherwise, returns nil.
---@param str string
---@param prefix string
---@return string?
function M.remove_prefix(str, prefix)
  if M.starts_with(str, prefix) then
    return str:sub(prefix:len() + 1)
  end
end

---Checks if a string ends with a given suffix.
---@param str string
---@param suffix string
---@return boolean
function M.ends_with(str, suffix)
  return str:sub(-suffix:len()) == suffix
end

---Checks if a string ends with a given suffix, and if it does, returns a substring without
---that suffix. Otherwise, returns nil.
---@param str string
---@param suffix string
---@return string?
function M.remove_suffix(str, suffix)
  if M.ends_with(str, suffix) then
    return str:sub(1, -suffix:len() - 1)
  end
end

---Recurses through a table with the given keys.
---@param tabl table
---@param ... string|integer Nested table keys
---@return any? # The nested value, or nil if not found
function M.get_nested(tabl, ...)
  for i = 1, select("#", ...) do
    local key = select(i, ...)
    if type(tabl) ~= "table" or tabl[key] == nil then
      return nil
    end
    tabl = tabl[key]
  end

  return tabl
end

---Iterates only the keys of the given table.
---@generic K
---@param tabl table<K, any>
---@return fun(t: table<K, any>, index: K): K?
---@return table<K, any>, K?
function M.keys(tabl)
  local function iter(t, index)
    local k, _ = next(t, index)
    return k
  end

  return iter, tabl, nil
end

---Creates a table with keys from an array of strings.
---@param list string[]
---@return table<string, boolean>
function M.set(list)
  local result = {}
  for i = 1, #list do
    result[list[i]] = true
  end
  return result
end

---Resolves an iterator into a table.
---@generic K, V, E
---@param iter fun(t: table<K, V>, index: K): K?, E?
---@param tabl table<K, V>
---@param index K?
---@return table<K, E>
function M.collect(iter, tabl, index)
  local result = {}
  for k, v in iter, tabl, index do
    if type(k) == "integer" then
      table.insert(result, v)
    else
      result[k] = v
    end
  end
  return result
end

---Iterates a table and retains only the values that satisfy the given predicate.
---By default, it removes existing nil or false items.
---@generic K, V
---@param tabl table<K, V>
---@param predicate? fun(V): boolean
---@return fun(t: table<K, V>, index: K): K?, V?
---@return table<K, V>, K?
function M.filter(tabl, predicate)
  local function iter(t, index)
    local k, v = next(t, index)
    while k and not ((predicate == nil and v) or (predicate ~= nil and predicate(v))) do
      k, v = next(t, k)
    end
    return k, v
  end

  return iter, tabl, nil
end

---Iterates a table and performs a function on every value of the table.
---@generic K, V, E
---@param tabl table<K, V>
---@param fn fun(V): E
---@return fun(t: table<K, V>, index: K): K?, E?
---@return table<K, V>, K?
function M.map(tabl, fn)
  local function iter(t, index)
    local k, v = next(t, index)
    if v then
      return k, fn(v)
    end
  end

  return iter, tabl, nil
end

---Iterates a table, performs a map operation, and filters out any nil or false results.
---@generic K, V, E
---@param tabl table<K, V>
---@param fn fun(V): E?
---@return fun(t: table<K, V>, index: K): K?, E?
---@return table<K, V>, K?
function M.filter_map(tabl, fn)
  local map = M.map(tabl, fn)
  local function iter(t, index)
    local k, v = map(t, index)
    while k and not v do
      k, v = map(t, k)
    end
    return k, v
  end

  return iter, tabl, nil
end

return M
