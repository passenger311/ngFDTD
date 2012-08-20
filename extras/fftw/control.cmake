
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
set(ARCHIVES ${NAME}-lib ${NAME}-threads-lib)
set(EXECUTABLES )
set(HEADERS )
set(INSTALL true)
set(BUILD_IN_SOURCE on)

### build flags

set(C_FLAGS "${C_REL} ${C_OPT2}")

set(FFTW_ENABLE_SIMD SSE3)
set(FFTW_ENABLE_THREADS 1)
set(FFTW_CONFIGURE_OPTIONS )
