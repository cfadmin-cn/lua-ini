local type = type
local assert = assert
local insert = table.insert

local ini = { __VERSION__ = 0.1 }

---comment 从string内解析ini结构
---@param buffer string            @合法的ini字符串
---@param need_comment boolean     @是否保留comment
---@return table                   @合法的lua table
function ini.loadstring(buffer, need_comment)
  local line_number = 1
  local config = { comments = { } }
  local section
  for line in buffer:gmatch("([^\r\n]+)") do
    -- 去除空格
    local l = line:gsub(" ", "")
    -- 如果不是被注释的一行
    local head = l:byte(1)
    if head ~= 59 then
      -- 如果是section类型
      if head == 91 then
        section = assert(l:match("%[(.+)%]"), "[INI ERROR] : No empty sections are allowed in the [" .. line_number .. "] line.")
        local v = config[section]
        assert(not v or type(v) == 'table', "[INI ERROR] : There are conflicting key-values or sections in section [" .. section .. "].")
        if not v then -- 如果之前没有section则创建一个.
          config[section] = {}
        end
      else
        local tab = config[section]
        if not tab then
          local key, value = l:match("([^=;]+)=([^ ;]+)")
          assert(key and value, "[INI ERROR] : An invalid key-value pair was found in the [" .. line_number .. "] line.")
          config[key] = value
        else
          local key, value = l:match("([^=;]+)=([^ ;]+)")
          config[section][key] = value
        end
      end
    else
      if need_comment then
        insert(config.comments, line)
      end
    end
    -- print("[" .. line .. "]")
    line_number = line_number + 1
  end
  if not need_comment then
    config.comments = nil
  end
  return config
end

---comment 从文件内解析ini结构
---@param filename     string      @已存在并合法的ini文件名
---@param need_comment boolean     @是否保留comment
---@return table                   @合法的lua table
function ini.loadfile(filename, need_comment)
  local f, err = io.open(filename, "rb")
  if not f then
    return false, err
  end
  local buffer = f:read "*a"
  f:close()
  return ini.loadstring(buffer, need_comment)
end

return ini