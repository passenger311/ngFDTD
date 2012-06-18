cmake_minimum_required(VERSION 2.8)

#include("../main.cmake")


add_executable(main main.cxx)

macro_install_libs(main)