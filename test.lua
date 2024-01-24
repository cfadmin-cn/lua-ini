require "utils"
local ini = require "ini"

local buffer =
[[
[PostgreSQL]
Description="ODBC for" PostgreSQL
Driver=/usr/lib/psqlodbcw.so
Setup=/usr/lib/libodbcpsqlS.so
Driver64=/usr/lib64/psqlodbcw.so
Setup64=/usr/lib64/libodbcpsqlS.so
FileUsage=1

[MySQL]
Description = ODBC for MySQL
Driver=/usr/lib/libmyodbc5.so
Setup=/usr/lib/libodbcmyS.so
Driver64=/usr/lib64/libmyodbc5.so
Setup64=/usr/lib64/libodbcmyS.so
FileUsage=1

[FreeTDS]
Description=Free Sybase & MS SQL Driver
Driver=/usr/lib/libtdsodbc.so
Setup=/usr/lib/libtdsS.so
Driver64=/usr/lib64/libtdsodbc.so
Setup64=/usr/lib64/libtdsS.so
Port=1433

[MariaDB]
Description=ODBC for MariaDB
Driver=/usr/lib/libmaodbc.so
Driver64=/usr/lib64/libmaodbc.so
FileUsage=1

[MySQL ODBC 8.0 Unicode Driver]
Driver=/usr/lib64/libmyodbc8w.so
UsageCount=1

[MySQL ODBC 8.0 ANSI Driver]
Driver=/usr/lib64/libmyodbc8a.so
UsageCount=1
]]

local t, err = ini.load(buffer)
if not t then
  return print(false, err)
end

var_dump(t)
