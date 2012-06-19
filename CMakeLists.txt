cmake_minimum_required(VERSION 2.8)

#### set project name and language support

project(ngFDTD CXX C Fortran)

#### set project version

set(PROJECT_MAJOR_VERSION 0) 
set(PROJECT_MINOR_VERSION 0)
set(PROJECT_PATCH_VERSION 1)

#### main hook (* do not change *)

include(main.cmake)

#### host specific setup

include(setup/compiler.cmake)    # compiler flags
include(setup/search.cmake)      # package search locations
include(setup/install.cmake)     # install prefix
include(setup/package.cmake)     # packaging settings

#### specify build targets below this line ...

require(source/geo)

#require(extras/lua)
#require(extras/boost)
#require(extras/fftw)
#require(extras/eigen3)
#require(extras/LuaJIT)
#require(extras/luasocket)
