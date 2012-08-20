#### -*- cmake -*- 
##
## main
##
## global hook - include this file from any subdirectory!
##

#### protect build

if ( EXISTS "${CMAKE_CURRENT_BINARY_DIR}/CMakeLists.txt" )
  message(FATAL_ERROR "*** RUN CMAKE IN A BUILD DIRECTORY !!! ***\n(you may want to remove CMakeCache.txt CMakeFiles)")
endif()

####

get_property(PROJECT_MAIN_GUARD GLOBAL PROPERTY PROJECT_MAIN_GUARD)

if( NOT PROJECT_MAIN_GUARD )

set_property(GLOBAL
  PROPERTY
  PROJECT_MAIN_GUARD 1)

#### find top level directory

function(find_top_dir CURRENT_DIR RESULT_NAME)
  get_filename_component(CURRENT_DIR ${CURRENT_DIR} ABSOLUTE)
  if ( EXISTS "${CURRENT_DIR}/main.cmake" )
    set(${RESULT_NAME} ${CURRENT_DIR} PARENT_SCOPE)
  else()
    find_top_dir("${CURRENT_DIR}/.." ${RESULT_NAME})    
    set(${RESULT_NAME} ${${RESULT_NAME}} PARENT_SCOPE)
  endif()
endfunction()

find_top_dir(${CMAKE_CURRENT_SOURCE_DIR} PROJECT_HOME)

#### contains function

function(contains VARS STRING FOUND)
  unset(FOUND )
  foreach(VAR ${${VARS}})
    if ( ${STRING} STREQUAL ${VAR} )
      set(${FOUND} true)
    endif()
  endforeach()
endfunction()

#### import build tools

if ( NOT BUILD_HOST_TOOLS )
  include("${PROJECT_HOME}/tools/build/ImportExecutables.cmake"
    RESULT_VARIABLE RET)
endif()

if ( RET STREQUAL "NOTFOUND" )
  message(FATAL_ERROR "*** BUILD TOOLS FIRST !!! ***")
endif()

#### set module directory

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_HOME}/cmake/modules)

#### setup project

include(${PROJECT_HOME}/setup/project.cmake)

if ( NOT PROJECT ) 
   get_filename_component(PROJECT ${PROJECT_HOME} NAME)
endif()

if ( NOT PROJECT_LANGUAGES )
  set(PROJECT_LANGUAGES CXX C Fortran)
endif()

project(${PROJECT} ${PROJECT_LANGUAGES})

include(${PROJECT_HOME}/setup/compiler.cmake)
include(${PROJECT_HOME}/setup/search.cmake)
include(${PROJECT_HOME}/setup/install.cmake)
include(${PROJECT_HOME}/setup/package.cmake)

#### set version string

set(PROJECT_VERSION 
  "${PROJECT_MAJOR_VERSION}.${PROJECT_MINOR_VERSION}.${PROJECT_PATCH_VERSION}")

#### process install PREFIX variable

if( NOT PREFIX )
  set(PREFIX ${CMAKE_BINARY_DIR}/install)
endif()

set(CMAKE_INSTALL_PREFIX ${PREFIX})

#### select architecture file

#### setup "distclean" target



add_custom_target(distclean
  COMMAND ${CMAKE_MAKE_PROGRAM} clean
  COMMAND ${CMAKE_COMMAND} -D PROJECT_HOME:PATH=${PROJECT_HOME} -P ${PROJECT_HOME}/cmake/custom/distclean.cmake
  )

#### top build or local build?

if ( ${PROJECT_HOME} STREQUAL ${CMAKE_SOURCE_DIR} )
  set(TOP_BUILD ON)
endif()


#### require macro

macro(require PATH)

  set(PREV_TARGET ${TARGET}) # save previous targets name



  message("-> require ${PATH}")
  set(TARGET_PATH ${PATH})
  get_filename_component(NAME ${TARGET_PATH} NAME)
  get_filename_component(TARGET_DIR ${PROJECT_HOME}/${TARGET_PATH} ABSOLUTE)
  string(TOUPPER ${NAME} TARGET)

  get_property(${TARGET}_REQUIRE_GUARD GLOBAL PROPERTY ${TARGET}_REQUIRE_GUARD)
  
  set(G_VARS NAME TARGET TARGET_PATH TARGET_DIR BUILD SOURCE_NAME BUILD_VERSION FIND_VERSION UNTAR_CMD TARBALL INCLUDE_DIR LIBRARY_DIR LIBRARIES ARCHIVES EXECUTABLES HEADERS PATCH_DIR SOURCE_DIR BINARY_DIR BUILD_IN_SOURCE INSTALL)

  unset(SOURCE_NAME )

# erase values (no longer necessary)
#  foreach(VAR ${G_VARS})
#    unset(${VAR} )
#  endforeach()

  set(BUILD on)
    
  if( EXISTS "${TARGET_DIR}/control.cmake" ) 
    if ( NOT ${TARGET}_REQUIRE_GUARD ) # check guard
      message("-> include ${TARGET_DIR}/control.cmake")
    endif()
    include(${TARGET_DIR}/control.cmake)
  endif()
  
  set(${TARGET}_BUILD ${BUILD})
  
  if( BUILD ) 
    if( EXISTS "${TARGET_DIR}/patch/" ) 
      if ( NOT ${TARGET}_REQUIRE_GUARD ) # check guard
	message("-> ${TARGET_DIR}/patch/ exists")
      endif()
      set(PATCH_DIR ${TARGET_DIR}/patch/)
    endif()    
    if( TARBALL ) 
      set(SOURCE_DIR ${CMAKE_BINARY_DIR}/unpack/${SOURCE_NAME})
    else()
      set(SOURCE_DIR ${TARGET_DIR}/${SOURCE_NAME})
    endif()
    if (BUILD_IN_SOURCE)
      set(BINARY_DIR ${SOURCE_DIR})
    else()
      set(BINARY_DIR ${CMAKE_BINARY_DIR}/${TARGET_PATH}/${SOURCE_NAME})
    endif()
    unset(X)
    foreach(SUBDIR ${INCLUDE_DIR})
      set(X ${X} ${SOURCE_DIR}/${SUBDIR}) 
    endforeach()
    set(INCLUDE_DIR ${X})
    if ( LIBRARY_DIR )
      set(LIBRARY_DIR ${BINARY_DIR}/${LIBRARY_DIR})
    endif()
    
    # assign to target variables
    foreach(VAR NAME ${G_VARS})
      set(${TARGET}_${VAR} ${${VAR}})
    endforeach()

    # unpack tarball and patch source
    if ( TARBALL AND NOT EXISTS "${SOURCE_DIR}/")
      message("-> ${UNTAR_CMD} ${TARBALL} in ${CMAKE_BINARY_DIR}/unpack")
      file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/unpack)
      execute_process(COMMAND ${CMAKE_COMMAND} -E ${UNTAR_CMD} ${TARGET_DIR}/${TARBALL} 
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/unpack )
    endif()
    
    if( PATCH_DIR ) 
      file( COPY ${PATCH_DIR}/
	DESTINATION ${SOURCE_DIR}/
	PATTERN * ) 
    endif()
      
  else() # try to find package
    
    if( EXISTS "${TARGET_DIR}/find.cmake" ) 
      if ( NOT ${TARGET}_REQUIRE_GUARD ) # check guard
	message("-> include ${TARGET_DIR}/find.cmake")
      endif()
      include(${TARGET_DIR}/find.cmake)
      if ( NOT ${TARGET}_FOUND )
	message("-> WARNING: missing package ${NAME}!")
      endif()
    else()
      message("-> WARNING: skipping ${TARGET} (no find.cmake script)!")
    endif()
    
  endif()

  # add subdirectory if BUILD flag is set
  if ( NOT ${TARGET}_REQUIRE_GUARD ) # check guard

    foreach(VAR ${G_VARS})
      message("${TARGET}_${VAR} = ${${TARGET}_${VAR}}")
    endforeach()

    set_property(GLOBAL
      PROPERTY
      ${TARGET}_REQUIRE_GUARD 1)
    
    if ( BUILD )
      message("-> add ${SOURCE_DIR}")
      add_subdirectory(${SOURCE_DIR} ${BINARY_DIR})
    endif()
  
  endif()

  foreach(VAR ${G_VARS})
    set(${VAR} ${${PREV_TARGET}_${VAR}} )
#    message("RESTORED ${VAR} ${${PREV_TARGET}_${VAR}}")
  endforeach()

  # endif()
  
endmacro()


#### install path defaults

set(INSTALL_DIR_BINARY bin)
set(INSTALL_DIR_LIBRARY lib)
set(INSTALL_DIR_INCLUDE include)
set(INSTALL_DIR_LUA lua)
set(INSTALL_DIR_SHARE share)
set(INSTALL_DIR_DOC doc)

#### include macro scripts

include(${PROJECT_HOME}/cmake/macros/install_lua_all.cmake)
include(${PROJECT_HOME}/cmake/macros/install_binaries.cmake)
include(${PROJECT_HOME}/cmake/macros/install_headers.cmake)

#### load cmake modules

include(CheckCCompilerFlag)
include(CheckCXXCompilerFlag)
#include(CheckFortranCompilerFlag)

#### 

if ( CMAKE_CROSSCOMPILING ) 
  message("XXXXXXXXXXXX")
endif()

#### global project header file

if( EXISTS ${PROJECT_HOME}/config.h.in )
  configure_file(${PROJECT_HOME}/config.h.in ${PROJECT_HOME}/config.h)
  set_directory_properties(PROPERTIES
    ADDITIONAL_MAKE_CLEAN_FILES ${PROJECT_HOME}/config.h
    )
endif()

#### make build/tools directory

file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/tools)

#### summary

message("PROJECT_NAME = ${PROJECT_NAME}")
message("PROJECT_HOME = ${PROJECT_HOME}")
message("PROJECT_VERSION = ${PROJECT_VERSION}")
message("PREFIX = ${PREFIX}")
message("TOP_BUILD = ${TOP_BUILD}")

####

endif()