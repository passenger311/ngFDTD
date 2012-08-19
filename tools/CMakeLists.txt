cmake_minimum_required(VERSION 2.8)

set(BUILD_HOST_TOOLS on)

include("../main.cmake")

# tools required for build

#require(extras/lua)
require(extras/LuaJIT)

export(TARGETS 
  luajit-exe 
  NAMESPACE 
  host-
  FILE ${CMAKE_BINARY_DIR}/ImportExecutables.cmake )

