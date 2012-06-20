cmake_minimum_required(VERSION 2.8)

include("../../main.cmake")

require(extras/srlua)

install(FILES make_init.lua DESTINATION ${INSTALL_DIR_SHARE}/scripts/)
