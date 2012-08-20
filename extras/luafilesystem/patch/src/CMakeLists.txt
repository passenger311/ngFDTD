cmake_minimum_required(VERSION 2.8)

include_directories(${LUA_INCLUDE_DIR})

set(LD_LIBS )

set(SRCS 
  lfs.c
)

if ( LIBRARIES ) 

  add_library(${NAME}-dll SHARED ${SRCS})
  target_link_libraries(${NAME}-dll ${LD_LIBS})
  
  set_target_properties(${NAME}-dll
    PROPERTIES 
    OUTPUT_NAME ${NAME}
    PREFIX ""
    COMPILE_FLAGS "${C_FLAGS}"
    )

endif()

if ( ARCHIVES )

  add_library(${NAME}-lib STATIC ${SRCS})
  target_link_libraries(${NAME}-lib ${LD_LIBS})
  
  set_target_properties(${NAME}-lib
    PROPERTIES 
    OUTPUT_NAME ${NAME}
    PREFIX ""
    COMPILE_FLAGS "${C_FLAGS}"
    )

endif()

if ( INSTALL ) 

  install(TARGETS 
    ${LIBRARIES}
    ${EXCECUTABLES}
    ${ARCHIVES}
    RUNTIME DESTINATION ${INSTALL_DIR_BINARY}
    LIBRARY DESTINATION ${INSTALL_DIR_LIBRARY}
    ARCHIVE DESTINATION ${INSTALL_DIR_LIBRARY}
    )

  install(FILES ${HEADERS} DESTINATION ${INSTALL_DIR_INCLUDE} )

endif()
