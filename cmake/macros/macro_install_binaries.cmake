
## install_binaries
##
## install libs, dlls and executables

macro(macro_install_binaries TARGETS)

install(TARGETS 
  ${TARGETS}
  RUNTIME DESTINATION ${INSTALL_DIR_BINARY}
  LIBRARY DESTINATION ${INSTALL_DIR_LIBRARY}
  ARCHIVE DESTINATION ${INSTALL_DIR_LIBRARY}
)

endmacro()