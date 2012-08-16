
#include <lua.h>
#include <lauxlib.h>

#include <string.h>
#include <stdio.h>

#define NLEN sizeof(lua_Number)
#define ILEN sizeof(int)

/* convert scalar types into the equivalent string of bytes */

int bytecast_tostring(lua_State *L) {
  lua_Number n;
  int b;
  char nstr[NLEN+1];
  if ( lua_gettop(L) >= 1 ) {
    if ( lua_isnumber(L,-1) ) {
      n = lua_tonumber(L,-1);
      memcpy(nstr, (const char*)&n, NLEN);
      lua_pushlstring(L, nstr, NLEN);
    } else if ( lua_isboolean(L,-1) ) {
      b = lua_toboolean(L,-1);
      if ( b ) {
	lua_pushlstring(L, "\1", 1);    
      } else {
	lua_pushlstring(L, "\0", 1);    
      }
    } else if ( lua_isstring(L,-1) ) {
    } else {
      lua_pushstring(L,"argument 1 must be scalar type");
      lua_error(L);
    }
  } else {
    lua_pushstring(L, "");    
  }
  return 1;
}


int bytecast_size(lua_State *L) {
  size_t len;
  if ( lua_gettop(L) >= 1 ) {
    if ( lua_isnumber(L,-1) ) {
      lua_pushnumber(L,NLEN);
    } else if ( lua_isboolean(L,-1) ) {
      lua_pushnumber(L,1);
    } else if ( lua_isstring(L,-1) ) {
      lua_tolstring(L,-1,&len);
      lua_pushnumber(L,len);
    } else {
      lua_pushstring(L,"argument 1 must be scalar type");
      lua_error(L);
    }
  } else {
    lua_pushnumber(L,0);    
  }
  return 1;
}

int bytecast_tonumber(lua_State *L) {
  const char * str;
  lua_Number num;
  size_t len;
  int pos = 0;
  int args = lua_gettop(L);
  if ( !lua_isstring(L,1) || args == 0 ) {
    lua_pushstring(L,"argument 1 must be string");
    lua_error(L);
  }
  str = lua_tolstring(L,1, &len);
  if ( args == 2 && lua_isnumber(L,2) ) {
    pos = lua_tonumber(L,2)-1;
  }
  if ( NLEN + pos <= len && pos >= 0 ) {
    memcpy((char *)&num, str+pos, NLEN);
    lua_pushnumber(L,num);
  } else {
    lua_pushnil(L);
  }
  return 1;
}

int bytecast_toboolean(lua_State *L) {
  const char * str;
  size_t len;
  int pos = 0;
  int args = lua_gettop(L);
  if ( !lua_isstring(L,1) || args == 0 ) {
    lua_pushstring(L,"argument 1 must be string");
    lua_error(L);
  }
  str = lua_tolstring(L,1, &len);
  if ( args == 2 && lua_isnumber(L,2) ) {
    pos = lua_tonumber(L,2)-1;
  }
  if ( pos < len && pos >= 0 ) {
    if ( *(str+pos) == '\0' ) {
      lua_pushboolean(L,1);
    } else {
      lua_pushboolean(L,0);
    }
  } else {
    lua_pushnil(L);
  }
  return 1;
}

