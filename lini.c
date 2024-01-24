/*
**  LICENSE: BSD
**  Author: CandyMi[https://github.com/candymi]
*/
#define LUA_LIB

#include "ini.h"

void* ini_malloc(size_t size)
{
  return xmalloc(size);
}

void ini_free(void* ptr)
{
  xfree(ptr);
}

void* ini_realloc(void* ptr, size_t size)
{
  return xrealloc(ptr, size);
}

static int ini_action(void* user, const char* section, const char* name, const char* value, int lineno)
{
  lua_State *L = (lua_State *)user; (void)lineno;
  // xrio_log("[%d]: [section] = `%s`, [key] = `%s`, [value] = `%s`\n", lineno, section, name, value);
  int type = lua_getfield(L, -1, section);
  if (type != LUA_TTABLE) {
    lua_pop(L, 1);
    lua_newtable(L);
  }
  lua_pushstring(L, value); lua_setfield(L, -2, name);
  // xrio_log("set successed. \n");
  if (type != LUA_TTABLE)
    lua_setfield(L, -2, section);
  else
    lua_pop(L, 1);
  return 1;
}

static int ini_load(lua_State *L)
{
  const char *content = luaL_checkstring(L, 1);
  if (!content || strlen(content) < 1)
    return luaL_error(L, "[ini error]: Invalid ini format content.");
  
  lua_settop(L, 1); lua_newtable(L);
  int lineno = ini_parse_string(content, ini_action, L);
  if (lineno) {
    lua_pushboolean(L, 0);
    lua_pushfstring(L, "[ini error]: parse error in line `%d`.", lineno);
    return 2;
  }
  return 1;
}

static int ini_loadfile(lua_State *L)
{
  const char *filename = luaL_checkstring(L, 1);
  if (!filename || strlen(filename) < 1)
    return luaL_error(L, "[ini error]: Invalid ini filename `%s`.", filename);
  
  FILE *fp = fopen(filename, "rb");
  if (!fp)
    return luaL_error(L, "[ini error]: can't find ini filename `%s`.", filename);

  lua_settop(L, 1); lua_newtable(L);
  int lineno = ini_parse_file(fp, ini_action, L);
  if (lineno) {
    fclose(fp);
    lua_pushboolean(L, 0);
    lua_pushfstring(L, "[ini error]: parse error in line `%d`.", lineno);
    return 2;
  }
  fclose(fp);
  return 1;
}

LUAMOD_API int luaopen_ini(lua_State *L)
{
  luaL_checkversion(L);
  const luaL_Reg ini_libs[] = {
    {"load", ini_load},
    {"loadfile", ini_loadfile},
    {NULL, NULL},
  };
  luaL_newlib(L, ini_libs);
  return 1;
}