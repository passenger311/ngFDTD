
#### install locations

# override install prefix

# default: set(PREFIX ${PROJECT_HOME}/build/install)

#### runtime

# this is not "safe" but should suit most needs

set(CMAKE_INSTALL_NAME_DIR "@executable_prefix/../lib")
set(CMAKE_INSTALL_RPATH "$ORIGIN/../lib")

#### relative install path

set(INSTALL_DIR_BINARY bin)
set(INSTALL_DIR_LIBRARY lib)
set(INSTALL_DIR_INCLUDE include)
set(INSTALL_DIR_SHARE share)
set(INSTALL_DIR_DOC doc)
