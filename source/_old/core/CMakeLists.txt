cmake_minimum_required(VERSION 2.8)

include("../../main.cmake")

### requirements

require(extras/lua)
require(extras/boost)

### source directories

add_subdirectory(src)
