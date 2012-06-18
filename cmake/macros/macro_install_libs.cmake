
## install_libs
##
## install libs, dlls and executables

macro(macro_install_libs TARGETS)

install(TARGETS 
  ${TARGETS}
  RUNTIME DESTINATION ${INSTALL_DIR_BINARY}
  LIBRARY DESTINATION ${INSTALL_DIR_LIBRARY}
  ARCHIVE DESTINATION ${INSTALL_DIR_LIBRARY}
)

endmacro()