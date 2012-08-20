cmake_minimum_required(VERSION 2.8)

set(LUAWRAP_SRC luawrap/LuaContext.cpp)

include_directories(${LUA_INCLUDE_DIR} ${BOOST_INCLUDE_DIR})

add_library(neo-lib STATIC ${LUAWRAP_SRC})
set_target_properties(neo-lib 
  PROPERTIES 
  COMPILE_FLAGS "${C_FLAGS} -std=c++0x"
  OUTPUT_NAME "neofdtd"
)

add_executable(test-exe luawrap/test.cxx ${LUAWRAP_SRC})
set_target_properties(test-exe 
  PROPERTIES 
  COMPILE_FLAGS "${C_FLAGS} -std=c++0x"
  OUTPUT_NAME "test"
)
target_link_libraries(test-exe lua-lib dl)