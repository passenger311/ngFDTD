
set(LD_LIBS m)

#if ( UNIX )
#  set(LD_LIBS ${LD_LIBS} dl readline)
#  set(C_FLAGS "${C_FLAGS} -DLUA_USE_LINUX" )
#endif()


set(CORE_SRCS 
  lapi.c lcode.c ldebug.c ldo.c ldump.c lfunc.c lgc.c llex.c lmem.c lobject.c 
  lopcodes.c lparser.c lstate.c lstring.c ltable.c ltm.c lundump.c lvm.c 
  lzio.c )

set(LIB_SRCS 
  lauxlib.c lbaselib.c ldblib.c liolib.c lmathlib.c loslib.c ltablib.c lstrlib.c
  loadlib.c linit.c )
set(DEV_HDRS lua.h lualib.h lauxlib.h luaconf.h )
set(LUA_SRCS lua.c  )
set(LUAC_SRCS luac.c )
set(LIBLUA_SRCS ${CORE_SRCS} ${LIB_SRCS})

if ( LIBRARIES )

  add_library(lua-dll SHARED ${LIBLUA_SRCS} )
  set_target_properties(lua-dll 
    PROPERTIES 
    COMPILE_FLAGS "${C_FLAGS}"
    OUTPUT_NAME "lua5.1"
    )

endif()

if ( ARCHIVES )

  add_library(lua-lib STATIC ${LIBLUA_SRCS} )
  set_target_properties(lua-lib 
    PROPERTIES 
    COMPILE_FLAGS "${C_FLAGS}"
    OUTPUT_NAME "lua5.1"
    )

endif()

if ( EXECUTABLES )

  add_executable(lua-exe ${LUA_SRCS} )
  set_target_properties(lua-exe 
    PROPERTIES 
    OUTPUT_NAME "lua"
    COMPILE_FLAGS "${C_FLAGS}"
    )
  target_link_libraries(lua-exe lua-dll ${LD_LIBS})
  
endif()


if ( INSTALL )

  install(TARGETS 
    ${EXECUTABLES}
    ${LIBRARIES}
    ${ARCHIVES}
    RUNTIME DESTINATION ${INSTALL_DIR_BINARY}
    LIBRARY DESTINATION ${INSTALL_DIR_LIBRARY}
    ARCHIVE DESTINATION ${INSTALL_DIR_LIBRARY}
    )
  
  if ( HEADERS )
    install(FILES ${HEADERS} DESTINATION ${INSTALL_DIR_INCLUDE}/lua5.1 )
  endif()
  
endif()
