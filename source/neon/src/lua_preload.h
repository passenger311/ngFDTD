#ifndef __LUA_PRELOAD__
#define __LUA_PRELOAD__

#ifndef LUAOPEN_API 
#define LUAOPEN_API 
#endif

LUAOPEN_API int lua_preload(lua_State *L);

#endif /* __LUA_PRELOAD__ */
