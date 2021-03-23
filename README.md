## lua-ini
  
  ini parsing library implemented by pure lua.

## Usage

  * First use `local ini = require "ini"` to import dependent libraries.

  * Then, the built-in `ini.loadstring` or `ini.loadfile` method can choose to parse the `ini` structure from the file or string into a lua table.

## Function signature

  * `function ini.loadstring(buffer, need_comment) table | nil, err end`

  * `function ini.loadfile(filename, need_comment) table | nil, err end`

## Example

  Please refer to the `test.lua` file.

## LICENSE

  [MIT](https://github.com/CandyMi/lua-ini/blob/master/LICENSE)
