#### -*- cmake -*- 
##
## main
##
## global hook - include this file from any subdirectory!
##

if( NOT MAIN_CMAKE_GUARD )

set(MAIN_CMAKE_GUARD 1)

#### version string

set(PROJECT_VERSION 
  "${PROJECT_MAJOR_VERSION}.${PROJECT_MINOR_VERSION}.${PROJECT_PATCH_VERSION}")

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

#### set module directory

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_HOME}/cmake/macros ${PROJECT_HOME}/cmake/modules)

#### require macro

macro(require PATH)

  message("-> require ${TARGET_PATH}")
  set(TARGET_PATH ${PATH})
  get_filename_component(TARGET_NAME ${TARGET_PATH} NAME)
  get_filename_component(TARGET_DIR ${PROJECT_HOME}/${TARGET_PATH} ABSOLUTE)
  string(TOUPPER ${TARGET_NAME} TARGET)
  set(NAME ${TARGET_NAME})
  set(TARGET_NAME ${TARGET_NAME})
  set(TARGET_PATH ${TARGET_PATH})
  set(TARGET_DIR ${TARGET_DIR})

  get_property(${TARGET}_REQUIRE_GUARD GLOBAL PROPERTY ${TARGET}_REQUIRE_GUARD)
  
  set(G_VARS BUILD SOURCE_NAME BUILD_VERSION FIND_VERSION UNTAR_CMD TARBALL INCLUDE_DIR LIBRARY_DIR LIBRARIES ARCHIVES PATCH_DIR SOURCE_DIR BINARY_DIR BUILD_IN_SOURCE)

  # erase values
  foreach(VAR ${G_VARS})
    unset(${VAR} )
  endforeach()
    
  set(BUILD on)
    
  if( EXISTS "${TARGET_DIR}/CONTROL.cmake" ) 
    message("-> include ${TARGET_DIR}/CONTROL.cmake")
    include(${TARGET_DIR}/CONTROL.cmake)
  endif()
  
  set(${TARGET}_BUILD ${BUILD})
  
  if( BUILD ) 
    if( EXISTS "${TARGET_DIR}/PATCH/" ) 
      message("-> ${TARGET_DIR}/PATCH/ exists")
      set(PATCH_DIR ${TARGET_DIR}/PATCH/)
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
    foreach(VAR ${G_VARS})
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
    
    if( EXISTS "${TARGET_DIR}/FIND.cmake" ) 
      message("-> include ${TARGET_DIR}/FIND.cmake")
      include(${TARGET_DIR}/FIND.cmake)
      if ( NOT ${TARGET}_FOUND )
	message("-> WARNING: missing package ${NAME}!")
      endif()
    else()
      message("-> WARNING: skipping ${TARGET} (no FIND.cmake script)!")
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

include(macro_install_lua_all)
include(macro_install_binaries)
include(macro_install_headers)

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

endif(NOT MAIN_CMAKE_GUARD)