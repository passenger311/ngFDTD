cmake_minimum_required(VERSION 2.8)

require("extras/LuaJIT")
require("extras/luafilesystem")
require("extras/luasocket")

get_target_property(CMD host-luajit-exe  IMPORTED_LOCATION_NOCONFIG)

execute_process(
  COMMAND ${CMD} create_glue_code.lua
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  RESULT_VARIABLE RET
  OUTPUT_VARIABLE OUT
  ERROR_VARIABLE ERR
)

if ( ERR ) 
  message("\n${OUT}")
  message(FATAL_ERROR "*** LUA-IMPORT FAILED !!! ***")
endif()

require(source/neon)
