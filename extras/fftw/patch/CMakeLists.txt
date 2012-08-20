#### CMakeLists.txt: fftw

#### compile

set(FFTW_LD_FLAGS -Wl,-rpath=$$ORIGIN/../lib)

#### create dummy target libraries 
#    note 1: this is a neat trick to add the libraries to cmake's build process
#    even though the libraries are build with ./configure 

file(MAKE_DIRECTORY lib)

if( LIBRARIES )

  add_library(${NAME}-dll SHARED dummy.c)
  set_target_properties(${NAME}-dll
    PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib
    VERSION ${BUILD_VERSION}
    OUTPUT_NAME fftw3
    )
  
  if ( FFTW_ENABLE_THREADS )
    
    add_library(${NAME}-threads-dll SHARED dummy.c)
    set_target_properties(${NAME}-threads-dll
      PROPERTIES
      ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib
      LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib
      RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib
	VERSION ${BUILD_VERSION}
	OUTPUT_NAME fftw3_threads
	)
      
    endif()

  set(FFTW_CONFIGURE_OPTIONS ${FFTW_CONFIGURE_OPTIONS} --enable-shared)
  
endif()

if ( ARCHIVES )

  add_library(${NAME}-lib STATIC dummy.c)
  set_target_properties(${NAME}-lib
    PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib
    VERSION ${BUILD_VERSION}
    OUTPUT_NAME fftw3
    )
  
  if ( FFTW_ENABLE_THREADS )
    
    add_library(${NAME}-threads-lib STATIC dummy.c)
    set_target_properties(${NAME}-threads-lib
      PROPERTIES
      ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib
      LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib
      RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib
      VERSION ${BUILD_VERSION}
      OUTPUT_NAME fftw3_threads
      )
    
  endif()

  else()
    set(FFTW_CONFIGURE_OPTIONS ${FFTW_CONFIGURE_OPTIONS} --disable-static)
  endif()

#### ./configure chain 
##   note: rpath is set to :::... as otherwise cmake can not change it during 
##   install

# removing the tags here seems to cause problems during build (do we need it?)
# file(REMOVE ${CMAKE_CURRENT_SOURCE_DIR}/configure_complete_tag)
# file(REMOVE ${CMAKE_CURRENT_SOURCE_DIR}/build_complete_tag)


#### configure settings

if( FFTW_ENABLE_SIMD STREQUAL "SSE" )
  set( FFTW_CONFIGURE_OPTIONS --enable-sse )
endif()
if( FFTW_ENABLE_SIMD STREQUAL "SSE2" )
  set( FFTW_CONFIGURE_OPTIONS --enable-sse2 )
endif()
if( FFTW_ENABLE_SIMD STREQUAL "SSE3" )
  set( FFTW_CONFIGURE_OPTIONS --enable-sse2 )
endif()
if( FFTW_ENABLE_SIMD STREQUAL "ALTIVEC" )
  set( FFTW_CONFIGURE_OPTIONS --enable-altivec )
endif()

if( FFTW_ENABLE_THREADS )
  set( FFTW_CONFIGURE_OPTIONS ${FFTW_CONFIGURE_OPTIONS} --enable-threads )
endif() 

#### configure command

add_custom_command( 
  OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/configure_complete_tag
  COMMAND LDFLAGS=-Wl,-rpath=:::::::::::::: CC=${CMAKE_C_COMPILER} F77=${CMAKE_Fortan_COMPILER} ./configure -C ${FFTW_CONFIGURE_OPTIONS} --prefix=${CMAKE_CURRENT_SOURCE_DIR}
  COMMAND ${CMAKE_COMMAND} -E touch ${CMAKE_CURRENT_SOURCE_DIR}/configure_complete_tag
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  VERBATIM
)

#### build command

add_custom_command( 
  OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/build_complete_tag
  COMMAND make 
  COMMAND make install
  COMMAND ${CMAKE_COMMAND} -E touch ${CMAKE_CURRENT_SOURCE_DIR}/build_complete_tag
  DEPENDS 
  ${CMAKE_CURRENT_SOURCE_DIR}/configure_complete_tag
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

add_custom_target( 
  ${NAME}-build ALL
  DEPENDS 
  ${CMAKE_CURRENT_SOURCE_DIR}/build_complete_tag
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)


add_dependencies(${NAME}-build ${NAME}-dll ${NAME}-lib ${NAME}-threads-dll ${NAME}-threads-lib )

if ( INSTALL )

  install(TARGETS 
    ${LIBRARIES}
    ${ARCHIVES}
    RUNTIME DESTINATION ${INSTALL_DIR_BINARY}
    LIBRARY DESTINATION ${INSTALL_DIR_LIBRARY}
    ARCHIVE DESTINATION ${INSTALL_DIR_LIBRARY}
    )

endif()

install(FILES include/fftw3.h DESTINATION ${INSTALL_DIR_INCLUDE})
