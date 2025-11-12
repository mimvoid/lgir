local table, ipairs, pairs = table, ipairs, pairs
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

---Recurses through a table with the given keys.
---@param tabl table
---@param ... string|integer Nested table keys
---@return any? # The nested value, or nil if not found
function M.get_nested(tabl, ...)
  for _, key in ipairs({ ... }) do
    if type(tabl) ~= "table" or tabl[key] == nil then
      return nil
    end

    tabl = tabl[key]
  end

  return tabl
end

---Creates an array of all keys in the given table.
---@generic T
---@param tabl table<T, any>
---@return T[]
function M.keys(tabl)
  local result = {}
  for k, _ in pairs(tabl) do
    table.insert(result, k)
  end
  return result
end

---Goes through an array and retains only the values that satisfy the given predicate.
---By default, it removes existing nil or false items.
---@generic T
---@param array T[]
---@param func? fun(T): boolean
---@return T[]
function M.filter(array, func)
  local result = {}

  for i = 1, #array do
    local item = array[i]

    -- Filter nil or false items by default, otherwise, call the function
    if (func == nil and item) or (func ~= nil and func(item)) then
      table.insert(result, item)
    end
  end

  return result
end

---Performs a function on every element of an array, and returns an array with the
---resulting values.
---@generic T, E
---@param array T[]
---@param func fun(T): E
---@return E[]
function M.map(array, func)
  local result = {}
  for i, v in ipairs(array) do
    result[i] = func(v)
  end
  return result
end

---Performs a map operation on the table and filters out any nil or false results.
---@generic T, E
---@param array T[]
---@param func fun(T): E?
---@return E[]
function M.filter_map(array, func)
  local result = {}

  for i = 1, #array do
    local mapped_item = func(array[i])
    if mapped_item then
      table.insert(result, mapped_item)
    end
  end

  return result
end

return M
