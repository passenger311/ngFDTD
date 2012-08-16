#ifndef __LUA_BYTECODE__
#define __LUA_BYTECODE__

#include <lua.h>

#ifndef LUAOPEN_API 
#define LUAOPEN_API 
#endif

LUAOPEN_API int luaopen_neon_start(lua_State *L);
LUAOPEN_API int luaopen_xlib_file_ostream(lua_State *L);
LUAOPEN_API int luaopen_xlib(lua_State *L);
LUAOPEN_API int luaopen_xlib_string_encode(lua_State *L);
LUAOPEN_API int luaopen_xlib_math_vector(lua_State *L);
LUAOPEN_API int luaopen_xlib_utils(lua_State *L);
LUAOPEN_API int luaopen_xlib_coroutine(lua_State *L);
LUAOPEN_API int luaopen_xlib_file(lua_State *L);
LUAOPEN_API int luaopen_xlib_debug(lua_State *L);
LUAOPEN_API int luaopen_xlib_os(lua_State *L);
LUAOPEN_API int luaopen_xlib_math_units(lua_State *L);
LUAOPEN_API int luaopen_xlib_string(lua_State *L);
LUAOPEN_API int luaopen_xlib_string_version(lua_State *L);
LUAOPEN_API int luaopen_xlib_io_fs(lua_State *L);
LUAOPEN_API int luaopen_xlib_math(lua_State *L);
LUAOPEN_API int luaopen_xlib_struct_deque(lua_State *L);
LUAOPEN_API int luaopen_xlib_struct_bag(lua_State *L);
LUAOPEN_API int luaopen_xlib_config(lua_State *L);
LUAOPEN_API int luaopen_xlib_struct_set(lua_State *L);
LUAOPEN_API int luaopen_xlib_module(lua_State *L);
LUAOPEN_API int luaopen_xlib_table(lua_State *L);
LUAOPEN_API int luaopen_xlib_object(lua_State *L);
LUAOPEN_API int luaopen_xlib_math_consts(lua_State *L);
LUAOPEN_API int luaopen_xlib_os_info(lua_State *L);
LUAOPEN_API int luaopen_xlib_math_complex(lua_State *L);
LUAOPEN_API int luaopen_xlib_math_dists(lua_State *L);
LUAOPEN_API int luaopen_xlib_proto(lua_State *L);
LUAOPEN_API int luaopen_xlib_struct(lua_State *L);
LUAOPEN_API int luaopen_xlib_unit(lua_State *L);
LUAOPEN_API int luaopen_xlib_io(lua_State *L);
LUAOPEN_API int luaopen_xlib_math_vec3(lua_State *L);
LUAOPEN_API int luaopen_xlib_math_quants(lua_State *L);
LUAOPEN_API int luaopen_xlib_class(lua_State *L);
LUAOPEN_API int luaopen_fdtd_array(lua_State *L);
LUAOPEN_API int luaopen_fdtd(lua_State *L);

#endif /* __LUA_BYTECODE__ */

