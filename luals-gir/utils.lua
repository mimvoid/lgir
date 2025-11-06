local M = {}

---Split a string by a separator
---@param str string
---@param sep string?
---@return string[]
function M.split(str, sep)
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
---@param prefix string
---@return boolean
function M.starts_with(str, prefix)
  local prefix_len = prefix:len()

  if prefix_len > str:len() then
    return false
  end

  local str_slice = str:sub(1, prefix_len)
  return str_slice == prefix
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
  local suffix_len = suffix:len()

  if suffix_len > str:len() then
    return false
  end

  local str_slice = str:sub(-suffix_len)
  return str_slice == suffix
end

---@param str string
---@param suffix string
---@return string?
function M.remove_suffix(str, suffix)
  local suffix_len = suffix:len()
  if suffix_len > str:len() then
    return nil
  end

  local str_slice = str:sub(-suffix_len)
  if str_slice ~= suffix then
    return nil
  end

  return str:sub(0, -suffix_len - 1)
end

---@generic T
---@generic E
---@param array T[]
---@param fun fun(T): E
---@return E[]
function M.map(array, fun)
  local res = {}
  for _, i in ipairs(array) do
    table.insert(res, fun(i))
  end
  return res
end

return M
