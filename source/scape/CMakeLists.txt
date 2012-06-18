cmake_minimum_required(VERSION 2.8)

include(../../main.cmake) # hook-up

require(extras/lua)       # requirement
require(extras/luasocket) # requirement

macro_install_lua() # install lua project files

add_subdirectory(src) # branch-down