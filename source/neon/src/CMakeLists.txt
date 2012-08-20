cmake_minimum_required(VERSION 2.8)

set(LD_LIBS m)

#### defaults

set(LD_LIBS ${LD_LIBS} dl)

#### check architecture 
## note: this is still very crude; FIXME set compiler flags properly as in
## original Makefile

if ( UNIX )
  set(LD_LIBS ${LD_LIBS} dl)
  set(C_FLAGS "${C_FLAGS} -DLUA_USE_LINUX" )
endif()

if( WIN32 )

endif()

if( APPLE )

endif()

#### sources

include_directories(
  ${LUAJIT_INCLUDE_DIR}
  )

add_executable(neon-exe neon.c linenoise.c lua_bytecode.c lua_preload.c)

set_target_properties(neon-exe
  PROPERTIES 
  LINK_FLAGS "${LD_FLAGS}"
  OUTPUT_NAME neon
)

target_link_libraries(neon-exe 
  ${LUAJIT_ARCHIVES} 
  ${LUAFILESYSTEM_ARCHIVES} 
  ${LUASOCKET_ARCHIVES}
  ${LD_LIBS}) 

add_executable(luajit-plain-exe luajit.c linenoise.c )

set_target_properties(luajit-plain-exe
  PROPERTIES 
  LINK_FLAGS "${LD_FLAGS}"
  OUTPUT_NAME luajit-plain
)

target_link_libraries(luajit-plain-exe ${LUAJIT_ARCHIVES} ${LD_LIBS}) 

### install

install(TARGETS 
  neon-exe
  luajit-plain-exe
  RUNTIME DESTINATION ${INSTALL_DIR_BINARY}
  LIBRARY DESTINATION ${INSTALL_DIR_LIBRARY}
  ARCHIVE DESTINATION ${INSTALL_DIR_LIBRARY}
)

#install(FILES ${DEV_HDRS} DESTINATION ${INSTALL_DIR_INCLUDE})
