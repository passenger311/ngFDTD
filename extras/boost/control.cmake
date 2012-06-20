
### build control

set(BUILD off)
set(FIND_VERSION 1.39.0) 
set(BUILD_VERSION 1.49.0) 
set(SOURCE_NAME ${NAME}_1_49_0)
set(TARBALL ${SOURCE_NAME}.tar.gz)
set(UNTAR_CMD tar xzf) 
set(INCLUDE_DIR src)
set(LIBRARY_DIR src)
set(LIBRARIES ${NAME}-dll)
set(BUILD_IN_SOURCE off)

### build flags

set(C_FLAGS "${C_REL} ${C_OPT2}")
