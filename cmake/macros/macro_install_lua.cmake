
## install_lua
##
## run the macro with same name from within lua project directory.

macro(macro_install_lua)

  get_filename_component(NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
  get_filename_component(PARENT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/.. ABSOLUTE)
  install(FILES ${PARENT_DIR}/${NAME}.lua DESTINATION ${INSTALL_DIR_SHARE})
  install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/ DESTINATION ${INSTALL_DIR_SHARE}/${NAME} FILES_MATCHING PATTERN "*.lua")
  install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/doc/html DESTINATION ${INSTALL_DIR_DOC}/${NAME} )

endmacro()