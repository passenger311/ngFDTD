
### build control

set(BUILD on)
set(FIND_VERSION 2.0.0)
set(BUILD_VERSION 2.0.0-beta10)
set(SOURCE_NAME ${NAME}-${BUILD_VERSION})
set(UNTAR_CMD tar xzf)
set(TARBALL ${SOURCE_NAME}.tar.gz)
set(INCLUDE_DIR src)
set(LIBRARY_DIR src)
set(LIBRARIES luajit-dll)
set(ARCHIVES luajit-lib)
set(HEADERS )
set(BUILD_IN_SOURCE off)

### build flags

set(C_FLAGS "${C_REL} ${C_OPT2} ${C_NOSTACK}")
