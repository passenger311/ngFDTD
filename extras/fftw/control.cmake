
### build control

set(BUILD on) 
set(FIND_VERSION 3.3.2)
set(BUILD_VERSION 3.3.2)
set(SOURCE_NAME ${NAME}-${BUILD_VERSION}) 
set(TARBALL ${SOURCE_NAME}.tar.gz)
set(UNTAR_CMD tar xzf) 
set(INCLUDE_DIR include)
set(LIBRARY_DIR lib)
set(LIBRARIES ${NAME}-dll ${NAME}-threads-dll)
set(ARCHIVES )
set(HEADERS )
set(BUILD_IN_SOURCE on)

### build flags

set(C_FLAGS "${C_REL} ${C_OPT2}")

set(FFTW_ENABLE_SIMD SSE3)
set(FFTW_ENABLE_THREADS 1)
set(FFTW_CONFIGURE_OPTIONS )

#### package build settings

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