
### build control

set(BUILD on)
set(INSTALL off)
set(FIND_VERSION 1.5.0)
set(BUILD_VERSION 1.5.0-16)
set(SOURCE_NAME ${NAME}-${BUILD_VERSION} )
set(UNTAR_CMD tar xzf )
set(TARBALL ${SOURCE_NAME}.tar.gz)
set(INCLUDE_DIR src)
set(LIBRARY_DIR src)
set(LIBRARIES ${NAME}-dll ) # ${NAME}-dll)
set(ARCHIVES ${NAME}-lib )
set(EXECUTABLES )
set(HEADERS luafilesystem.h )
set(BUILD_IN_SOURCE off)

### build flags

set(C_FLAGS "${C_REL} ${C_OPT2}")
