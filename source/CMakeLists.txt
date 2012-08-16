cmake_minimum_required(VERSION 2.8)


get_target_property(CMD host-luajit-exe  IMPORTED_LOCATION_NOCONFIG)

execute_process(
  COMMAND ${CMD} scripts/glue_main.lua
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  RESULT_VARIABLE RET
  OUTPUT_VARIABLE OUT
)

require(source/neon)
