
## install_headers
##
## install headers

macro(macro_install_headers FILES)

install(FILES ${FILES} DESTINATION ${INSTALL_DIR_INCLUDE})

endmacro()