cmake_minimum_required(VERSION 2.8)

set(C_FLAGS ${FLAGS_REL} ${FLAGS_OPT2})

require(extras/lua)

add_subdirectory(src)

