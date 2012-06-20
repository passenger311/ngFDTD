

require(extras/lua)

set(LD_LIBS m)

if ( UNIX )
  set(LD_LIBS ${LD_LIBS}  dl readline)
  set(C_FLAGS "${C_FLAGS} -DLUA_USE_LINUX" )
endif()

include_directories(${LUA_INCLUDE_DIR})

add_executable(srlua-glue-exe glue.c)

set_target_properties(srlua-glue-exe 
  PROPERTIES 
  OUTPUT_NAME "glue"
  COMPILE_FLAGS "${C_FLAGS}"
)

target_link_libraries(srlua-glue-exe lua-lib ${LD_LIBS})

add_executable(srlua-exe srlua.c)

set_target_properties(srlua-exe 
  PROPERTIES 
  OUTPUT_NAME "srlua"
  COMPILE_FLAGS "${C_FLAGS}"
)

target_link_libraries(srlua-exe lua-lib ${LD_LIBS})

macro_install_binaries( srlua-exe srlua-glue-exe )
