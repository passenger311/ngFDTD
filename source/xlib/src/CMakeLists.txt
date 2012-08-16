cmake_minimum_required(VERSION 2.8)

include_directories(${LUA_INCLUDE_DIR})

file(GLOB CFILES *.c)

add_library(core-dll SHARED ${CFILES})

set_target_properties(core-dll
  PROPERTIES
  OUTPUT_NAME core
  PREFIX ""
)

if(NOT DEFINED TOP_BUILD)
set_target_properties(core-dll
  PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/..
  LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/..
)
endif()

install(TARGETS 
  core-dll
  RUNTIME DESTINATION ${INSTALL_DIR_BINARY}/${NAME}
  LIBRARY DESTINATION ${INSTALL_DIR_LIBRARY}/${NAME}
  ARCHIVE DESTINATION ${INSTALL_DIR_LIBRARY}/${NAME}
)
 
if(WIN32)
  target_link_libraries(core-dll ${LUA_LIBRARIES})
endif()
