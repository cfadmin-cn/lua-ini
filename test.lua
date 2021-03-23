local ini = require "ini"

local config, err = ini.loadfile("test.ini")
if not config then
  return print(false, err)
end

for k, v in ipairs(config) do
  print("key = [" .. k .. "]", "value = [" .. v .. "]")
end