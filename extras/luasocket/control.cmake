
### build control

set(BUILD on)
set(FIND_VERSION 2.0.2)
set(BUILD_VERSION 2.0.2)
set(SOURCE_NAME ${NAME}-${BUILD_VERSION})
set(TARBALL ${SOURCE_NAME}.tar.gz)
set(UNTAR_CMD tar xzf)
set(INCLUDE_DIR ${NAME}-${VERSION}/src)
set(LIBRARY_DIR ${NAME}-${VERSION}/src)
set(LIBRARIES ${NAME}-socket-dll ${NAME}-mime-dll )
set(ARCHIVES ${NAME}-socket-lib ${NAME}-mime-lib )
set(HEADERS )
set(BUILD_IN SOURCE off)

if ( UNIX ) 
  set(LIBRARIES ${LIBRARIES} ${NAME}-unix-dll )
  set(ARCHIVES ${ARCHIVES} ${NAME}-unix-lib )
endif()

### build flags

set(C_FLAGS "${C_REL} ${C_OPT2}")
