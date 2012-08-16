
#include <lua.h>
#include <lauxlib.h>

/* known operating systems */

#if _WIN32 | _WIN64 | _WINDOWS | __WIN32__ | __CYGWIN32__

#define OS_TYPE "Windows"
#define OS_API "WIN32"

#endif

#if __linux

#define OS_TYPE "Linux"
#define OS_API "POSIX"

#endif

#if __FreeBSD__

#include <osreldate.h>

#define OS_TYPE "FreeBSD"
#define OS_VERSION __FreeBSD_version
#define OS_API "POSIX"

#endif

#if __APPLE__ & __MACH__

#define OS_TYPE "MacOSX"
#define OS_API "POSIX"

#endif

/* fallback definitions */

#ifndef OS_TYPE
#define OS_TYPE ""
#endif

#ifndef OS_POSIX
#include <unistd.h>
#if _POSIX_VERSION
#define OS_API "POSIX"
#else
#define OS_API ""
#endif
#endif

/* get list */

#define LITTLE_ENDIAN 1
#define BIG_ENDIAN 0

int machine_endianness()
{
   int i = 1;
   char *p = (char *) &i;
   if (p[0] == 1) 
     return LITTLE_ENDIAN;
   else
     return BIG_ENDIAN;
}

int osinfo_getlist(lua_State* L)
{
  char dummy;
  lua_pushstring(L, OS_TYPE);
  lua_pushstring(L, OS_API);
  lua_pushnumber(L, sizeof(&dummy)*8);
  lua_pushnumber(L, machine_endianness());
  return 4;
}

