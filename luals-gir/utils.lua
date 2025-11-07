local table = table
local M = {}

---Split a string by a separator
---@param str string
---@param sep string?
---@return string[]
function M.split(str, sep)
  if sep == nil then
    sep = "%s" -- Default to a space for the separator
  end

  local split_strs = {}

  for s in str:gmatch(string.format("([^%s]+)", sep)) do
    table.insert(split_strs, s)
  end

  return split_strs
end

---@param str string
---@param prefix string
---@return boolean
function M.starts_with(str, prefix)
  return str:sub(1, prefix:len()) == prefix
end

---@param str string
---@param prefix string
---@return string?
function M.remove_prefix(str, prefix)
  if M.starts_with(str, prefix) then
    return str:sub(prefix:len() + 1)
  end
end

---@param str string
---@param suffix string
---@return boolean
function M.ends_with(str, suffix)
  return str:sub(-suffix:len()) == suffix
end

---@param str string
---@param suffix string
---@return string?
function M.remove_suffix(str, suffix)
  if M.ends_with(str, suffix) then
    return str:sub(1, -suffix:len() - 1)
  end
end

---@param tabl table
---@param ... string|integer Nested table keys or indices
---@return any The nested value, or nil if not found
function M.get_nested(tabl, ...)
  for _, key in ipairs({ ... }) do
    if type(tabl) ~= "table" or tabl[key] == nil then
      return nil
    end

    tabl = tabl[key]
  end

  return tabl
end

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

return M
