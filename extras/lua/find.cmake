
set(LOCATIONS 
  ${LOCATIONS}
  $ENV{LUA_DIR}
)

find_path(LUA_INCLUDE_DIR lua.h
  PATHS
  ${LOCATIONS}
  PATH_SUFFIXES include/lua51 include/lua5.1 include/lua include
)

find_library(LUA_LIBRARIES
  NAMES lua51 lua5.1 lua
  PATHS
  ${LOCATIONS}
  PATH_SUFFIXES lib64 lib
)

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(Lua51 DEFAULT_MSG LUA_LIBRARIES LUA_INCLUDE_DIR)

if(LUA_LIBRARIES AND LUA_INCLUDE_DIR)
  set(LUA_FOUND TRUE)
endif()

mark_as_advanced(LUA_INCLUDE_DIR LUA_LIBRARIES LUA_LIBRARY LUA_MATH_LIBRARY)

