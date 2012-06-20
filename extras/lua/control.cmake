
### build control

set(BUILD on)
set(FIND_VERSION 5.1.4)
set(BUILD_VERSION 5.1.4)
set(SOURCE_NAME ${NAME}-${BUILD_VERSION})
set(TARBALL ${SOURCE_NAME}.tar.gz)
set(UNTAR_CMD tar xzf)
set(INCLUDE_DIR src)
set(LIBRARY_DIR src)
set(LIBRARIES ${NAME}-dll)
set(BUILD_IN_SOURCE off)

### build flags

set(C_FLAGS "${C_REL} ${C_OPT2}")
