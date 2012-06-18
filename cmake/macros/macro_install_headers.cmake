
## install_headers
##
## install headers

macro(macro_install_headers )

install(FILES ${ARGV} DESTINATION ${INSTALL_DIR_INCLUDE})

endmacro()