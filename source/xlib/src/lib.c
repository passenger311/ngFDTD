
#include <lua.h>
#include <lauxlib.h>

#include "sysclock.h"
#include "bytecast.h"
#include "osinfo.h"

static luaL_reg lib_reg[] = {
	{ "sysclock_gettime",  sysclock_gettime },
	{ "sysclock_resolution",  sysclock_resolution },
	{ "bytecast_tonumber", bytecast_tonumber },
	{ "bytecast_tostring", bytecast_tostring },
	{ "bytecast_toboolean", bytecast_toboolean },
	{ "bytecast_size",  bytecast_toboolean },
	{ "osinfo_getlist",  osinfo_getlist },
	{ NULL, NULL }
};

LUALIB_API int luaopen_scape_core(lua_State *L) {
	luaL_openlib(L, "scape.core", lib_reg, 0);
	return 1;
}
