cmake_minimum_required(VERSION 2.8)

include_directories(${LUA_INCLUDE_DIR})

set(LD_LIBS m)

if ( UNIX )
  set(LD_LIBS ${LD_LIBS} dl readline)
  set(C_FLAGS "${C_FLAGS} -DLUA_USE_LINUX" )
  set(SOCKET_C usocket.c unix.c)
endif()

if( WIN32 )
  set(LD_LIBS ${LD_LIBS} ws2_32)
  set(SOCKET_C wsocket.c)
endif()


set(DEV_HDRS
  luasocket.h
)

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

if ( UNIX )
set(UNIX_SRCS
  buffer.c
  auxiliar.c
  options.c
  timeout.c
  io.c
  ${SOCKET_C}
  unix.c
)
endif()

add_library(${NAME}-socket-dll SHARED ${SOCKET_SRCS})
add_library(${NAME}-mime-dll SHARED ${MIME_SRCS})

target_link_libraries(${NAME}-socket-dll ${NAME}-mime-dll ${LD_LIBS})

if( UNIX )
  add_library(${NAME}-unix-dll SHARED ${UNIX_SRCS})
  target_link_libraries(${NAME}-unix-dll ${LD_LIBS})
endif()


set_target_properties(${NAME}-socket-dll
  PROPERTIES 
  LIBRARY_OUTPUT_DIRECTORY socket
  ARCHIVE_OUTPUT_DIRECTORY socket
  RUNTIME_OUTPUT_DIRECTORY socket
  OUTPUT_NAME core
  PREFIX ""
  COMPILE_FLAGS "${C_FLAGS}"
)

set_target_properties(${NAME}-mime-dll
  PROPERTIES 
  LIBRARY_OUTPUT_DIRECTORY mime
  ARCHIVE_OUTPUT_DIRECTORY mime
  RUNTIME_OUTPUT_DIRECTORY mime
  OUTPUT_NAME core
  PREFIX ""
  COMPILE_FLAGS "${C_FLAGS}"
)

if ( UNIX )
set_target_properties(${NAME}-unix-dll
  PROPERTIES 
  OUTPUT_NAME unix
  PREFIX ""
  COMPILE_FLAGS "${C_FLAGS}"
)
endif()

if(WIN32)
  target_link_libraries(${NAME}-socket-dll ${LUA_LIBRARIES})
  target_link_libraries(${NAME}-mime-dll ${LUA_LIBRARIES})
endif()


install(TARGETS 
  ${NAME}-socket-dll
  RUNTIME DESTINATION ${INSTALL_DIR_BINARY}/socket
  LIBRARY DESTINATION ${INSTALL_DIR_LIBRARY}/socket
  ARCHIVE DESTINATION ${INSTALL_DIR_LIBRARY}/socket
)


install(TARGETS 
  ${NAME}-mime-dll
  RUNTIME DESTINATION ${INSTALL_DIR_BINARY}/mime
  LIBRARY DESTINATION ${INSTALL_DIR_LIBRARY}/mime
  ARCHIVE DESTINATION ${INSTALL_DIR_LIBRARY}/mime
)

if( UNIX )
  install(TARGETS 
    ${NAME}-unix-dll
    RUNTIME DESTINATION ${INSTALL_DIR_BINARY}/unix
    LIBRARY DESTINATION ${INSTALL_DIR_LIBRARY}/unix
    ARCHIVE DESTINATION ${INSTALL_DIR_LIBRARY}/unix
    )
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

install(FILES ${SOCKET_LUA} DESTINATION ${INSTALL_DIR_SHARE}/socket)
install(FILES ${OTHER_LUA} DESTINATION ${INSTALL_DIR_SHARE})
install(FILES ${DEV_HDRS} DESTINATION ${INSTALL_DIR_INCLUDE})
