
### Example CONTROL file.

### control build

set(BUILD on)                       # build package from source (or find) 
set(REQUIRED_VERSION 5.1.4)         # required version (for FIND.cmake)
set(SOURCE_NAME ${NAME}-5.1.4)      # name of source directory       
set(TARBALL ${SOURCE_NAME}.tar.gz)  # source archive
set(UNTAR_CMD tar xzf)              # extract command     
set(INCLUDE_DIR src)                # path(s) to include directorie(s)
set(LIBRARY_DIR src)                # path to library directory
set(LIBRARIES ${NAME}-dll)          # name(s) of libraries or cmake aliases
set(BUILD_IN_SOURCE off)            # build inside source directory

### build flags

set(C_FLAGS "${C_REL} ${C_OPT2}")
