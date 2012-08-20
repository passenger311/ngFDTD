cmake_minimum_required(VERSION 2.8)

include_directories(${LUA_INCLUDE_DIR})

set(LD_LIBS m)

if ( UNIX )
  set(SOCKET_C usocket.c)
endif()

if( WIN32 )
  set(SOCKET_C wsocket.c)
endif()

set(SOCKET_SRCS 
  luasocket.c
  timeout.c 
  buffer.c 
  io.c 
  auxiliar.c 
  options.c 
  inet.c 
  tcp.c 
  udp.c  
  except.c 
  select.c 
  ${SOCKET_C}
)

set(MIME_SRCS 
  mime.c
)

set(UNIX_SRCS
  buffer.c
  auxiliar.c
  options.c
  timeout.c
  io.c
  ${SOCKET_C}
  unix.c
)

if ( LIBRARIES )

  add_library(${NAME}-socket-dll SHARED ${SOCKET_SRCS})
  target_link_libraries(${NAME}-socket-dll ${LUA_LIBRARIES} ${NAME}-mime-dll ${LD_LIBS})
  set_target_properties(${NAME}-socket-dll
    PROPERTIES 
    ARCHIVE_OUTPUT_DIRECTORY socket
    LIBRARY_OUTPUT_DIRECTORY socket
    OUTPUT_NAME core
    PREFIX ""
    COMPILE_FLAGS "${C_FLAGS}"
    )

  add_library(${NAME}-mime-dll SHARED ${MIME_SRCS})
  target_link_libraries(${NAME}-mime-dll ${LUA_LIBRARIES})
  set_target_properties(${NAME}-mime-dll
    PROPERTIES 
    ARCHIVE_OUTPUT_DIRECTORY mime
    LIBRARY_OUTPUT_DIRECTORY mime
    OUTPUT_NAME core
    PREFIX ""
    COMPILE_FLAGS "${C_FLAGS}"
    )

  if ( UNIX ) 
    add_library(${NAME}-unix-dll SHARED ${UNIX_SRCS})
    target_link_libraries(${NAME}-unix-dll ${LD_LIBS})
    set_target_properties(${NAME}-unix-dll
      PROPERTIES 
      ARCHIVE_OUTPUT_DIRECTORY socket
      LIBRARY_OUTPUT_DIRECTORY socket
      OUTPUT_NAME unix
      PREFIX ""
      COMPILE_FLAGS "${C_FLAGS}"
      )
  endif()

endif()

if ( ARCHIVES )

  add_library(${NAME}-socket-lib STATIC ${SOCKET_SRCS})
  target_link_libraries(${NAME}-socket-lib ${LUA_LIBRARIES} ${NAME}-mime-lib ${LD_LIBS})
  set_target_properties(${NAME}-socket-lib
    PROPERTIES  
    ARCHIVE_OUTPUT_DIRECTORY socket
    LIBRARY_OUTPUT_DIRECTORY socket
    OUTPUT_NAME core
    PREFIX ""
    COMPILE_FLAGS "${C_FLAGS}"
    )

  add_library(${NAME}-mime-lib STATIC ${MIME_SRCS})
  target_link_libraries(${NAME}-mime-lib ${LUA_LIBRARIES})
  set_target_properties(${NAME}-mime-lib
    PROPERTIES 
    ARCHIVE_OUTPUT_DIRECTORY mime
    LIBRARY_OUTPUT_DIRECTORY mime
    OUTPUT_NAME core
    PREFIX ""
    COMPILE_FLAGS "${C_FLAGS}"
    )

  if ( UNIX ) 
    add_library(${NAME}-unix-lib STATIC ${UNIX_SRCS})
    target_link_libraries(${NAME}-unix-lib ${LD_LIBS})
    set_target_properties(${NAME}-unix-lib
      PROPERTIES 
      ARCHIVE_OUTPUT_DIRECTORY socket
      LIBRARY_OUTPUT_DIRECTORY socket
      OUTPUT_NAME unix
      PREFIX ""
      COMPILE_FLAGS "${C_FLAGS}"
      )
  endif()

endif()


set(SOCKET_LUA
  http.lua 
  url.lua 
  tp.lua 
  ftp.lua 
  smtp.lua
)

set(OTHER_LUA
  ltn12.lua
  socket.lua
  mime.lua
)


if ( INSTALL ) 

  install(TARGETS 
    ${NAME}-socket-dll
    ${NAME}-socket-lib
    RUNTIME DESTINATION ${INSTALL_DIR_BINARY}/socket
    LIBRARY DESTINATION ${INSTALL_DIR_LIBRARY}/socket
    ARCHIVE DESTINATION ${INSTALL_DIR_LIBRARY}/socket
    )
  
  install(TARGETS 
    ${NAME}-mime-dll
    ${NAME}-mime-lib
    RUNTIME DESTINATION ${INSTALL_DIR_BINARY}/mime
    LIBRARY DESTINATION ${INSTALL_DIR_LIBRARY}/mime
    ARCHIVE DESTINATION ${INSTALL_DIR_LIBRARY}/mime
    )

  if( UNIX )

    install(TARGETS 
      ${NAME}-unix-dll
      ${NAME}-unix-lib
      RUNTIME DESTINATION ${INSTALL_DIR_BINARY}/socket
      LIBRARY DESTINATION ${INSTALL_DIR_LIBRARY}/socket
      ARCHIVE DESTINATION ${INSTALL_DIR_LIBRARY}/socket
      )

  endif()

  install(FILES ${SOCKET_LUA} DESTINATION ${INSTALL_DIR_SHARE}/socket)
  install(FILES ${OTHER_LUA} DESTINATION ${INSTALL_DIR_SHARE})
  install(FILES ${HEADERS} DESTINATION ${INSTALL_DIR_INCLUDE})

endif()