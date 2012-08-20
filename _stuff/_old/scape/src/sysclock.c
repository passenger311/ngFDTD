
#include <lua.h>
#include <lauxlib.h>

/* get clock time in microseconds */

#ifdef _WIN32

#include <windows.h>

lua_Number impl_gettime()
{
  SYSTEMTIME systemTime;
  FILETIME fileTime;
  ULARGE_INTEGER uli;

  GetSystemTime( &systemTime );
  SystemTimeToFileTime( &systemTime, &fileTime );
  uli.LowPart = fileTime.dwLowDateTime; 
  uli.HighPart = fileTime.dwHighDateTime;
  return  ( (lua_Number)uli.QuadPart )* 1.e-7; /* time in secs */
}

#else

#include <time.h>
#include <sys/time.h>
#include <stdint.h>

lua_Number impl_gettime()
{
  struct timeval tp;
  struct timezone tzp;
  lua_Number time;
  (void)gettimeofday(&tp,&tzp);
  return ( (lua_Number) tp.tv_sec + (lua_Number) tp.tv_usec * 1.e-6 );
}

#endif


int sysclock_gettime(lua_State* L)
{
  lua_pushnumber(L, impl_gettime());
  return 1;
}

int sysclock_resolution(lua_State* L)
{
  lua_Number t1, t2;
  int i;
  t1 = impl_gettime();
  t2 = impl_gettime();
  while ( t1 == t2 ) t2 = impl_gettime();
  lua_pushnumber(L, t2-t1);
  return 1;
}



