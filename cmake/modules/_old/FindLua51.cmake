# Locate Lua library
# This module defines
#  LUA_LIBRARIES
#  LUA_FOUND, if false, do not try to link to Lua 
#  LUA_INCLUDE_DIR, where to find lua.h 
#
# Note that the expected include convention is
#  #include "lua.h"
# and not
#  #include <lua/lua.h>
# This is because, the lua location is not standardized and may exist
# in locations other than lua/


find_path(LUA_INCLUDE_DIR lua.h
  PATHS
  $ENV{LUA_DIR}
  NO_DEFAULT_PATH
  PATH_SUFFIXES include/lua51 include/lua5.1 include/lua include
)

find_path(LUA_INCLUDE_DIR lua.h
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /usr/local
  /usr
  /sw # Fink
  /opt/local # DarwinPorts
  /opt/csw # Blastwave
  /opt
  PATH_SUFFIXES include/lua51 include/lua5.1 include/lua include
)

find_library(LUA_LIBRARY 
  NAMES lua51 lua5.1 lua
  PATHS
  $ENV{LUA_DIR}
  NO_DEFAULT_PATH
    PATH_SUFFIXES lib64 lib
)

find_library(LUA_LIBRARY
  NAMES lua51 lua5.1 lua
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /usr/local
  /usr
  /sw
  /opt/local
  /opt/csw
  /opt
    PATH_SUFFIXES lib64 lib
)

if(LUA_LIBRARY)
  # include the math library for Unix
  if(UNIX AND NOT APPLE)
    find_library(LUA_MATH_LIBRARY m)
    set( LUA_LIBRARIES "${LUA_LIBRARY};${LUA_MATH_LIBRARY}" CACHE STRING "Lua Libraries")
  # For Windows and Mac, don't need to explicitly include the math library
  else(UNIX AND NOT APPLE)
    set( LUA_LIBRARIES "${LUA_LIBRARY}" CACHE STRING "Lua Libraries")
  endif(UNIX AND NOT APPLE)
endif(LUA_LIBRARY)

include(FindPackageHandleStandardArgs)

# handle the QUIETLY and REQUIRED arguments and set LUA_FOUND to TRUE if 
# all listed variables are TRUE
find_package_handle_standard_args(Lua51  DEFAULT_MSG  LUA_LIBRARIES LUA_INCLUDE_DIR)

if(LUA_LIBRARIES AND LUA_INCLUDE_DIR)
  set(LUA_FOUND TRUE)
endif()

mark_as_advanced(LUA_INCLUDE_DIR LUA_LIBRARIES LUA_LIBRARY LUA_MATH_LIBRARY)
