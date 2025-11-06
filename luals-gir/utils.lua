local M = {}

---Split a string by a separator
---@param str string
---@param sep string?
---@return string[]
M.split = function(str, sep)
  -- Set the separator to a space by default
  if sep == nil then
    sep = "%s"
  end

  local split_strs = {}

  for s in str:gmatch("([^" .. sep .. "]+)") do
    table.insert(split_strs, s)
  end

  return split_strs
end

---@param str string
---@param suffix string
---@return boolean
M.ends_with = function(str, suffix)
  local suffix_len = suffix:len()

  if suffix_len > str:len() then
    return false
  end

  local str_slice = str:sub(-suffix_len)
  return str_slice == suffix
end

---@generic T
---@generic E
---@param array T[]
---@param fun fun(T): E
---@return E[]
M.map = function(array, fun)
  local res = {}
  for _, i in ipairs(array) do
    table.insert(res, fun(i))
  end
  return res
end

return M
