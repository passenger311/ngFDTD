cmake_minimum_required(VERSION 2.8)

enable_language(ASM)

set(LD_LIBS m)

#### defaults

set(LJVM_MODE elfasm)
set(LD_LIBS ${LD_LIBS} dl)

#### check architecture 
## note: this is still a bit crude; FIXME set compiler flags properly as in
## original Makefile

if ( UNIX )
  set(LD_LIBS ${LD_LIBS} dl)
  set(C_FLAGS "${C_FLAGS} -DLUA_USE_LINUX" )
endif()

if( WIN32 )
  set(LJVM_MODE coffasm)
  
endif()

if( APPLE )
set(LJVM_MODE machasm)
endif()

#### sources


set(LJVM_SRCS 
  lj_vm.s
)
set(GEN_SRCS 
  ${LJVM_SRCS} lj_bcdef.h lj_ffdef.h lj_libdef.h lj_folddef.h lj_recdef.h)

set(BUILDVM_SRCS
  buildvm.c buildvm_asm.c buildvm_peobj.c buildvm_lib.c buildvm_fold.c
  )

set(LJLIB_SRCS 
  lib_base.c lib_math.c lib_bit.c lib_string.c lib_table.c 
  lib_io.c lib_os.c lib_package.c lib_debug.c lib_jit.c lib_ffi.c
  )

set(LJCORE_SRCS
  lj_gc.c lj_err.c lj_char.c lj_bc.c lj_obj.c 
  lj_str.c lj_tab.c lj_func.c lj_udata.c lj_meta.c lj_debug.c 
  lj_state.c lj_dispatch.c lj_vmevent.c lj_vmmath.c lj_api.c 
  lj_lex.c lj_parse.c lj_bcread.c lj_bcwrite.c 
  lj_ir.c lj_opt_mem.c lj_opt_fold.c lj_opt_narrow.c 
  lj_opt_dce.c lj_opt_loop.c lj_opt_split.c 
  lj_mcode.c lj_snap.c lj_record.c lj_crecord.c lj_ffrecord.c 
  lj_asm.c lj_trace.c lj_gdbjit.c 
  lj_ctype.c lj_cdata.c lj_cconv.c lj_ccall.c lj_ccallback.c 
  lj_carith.c lj_clib.c lj_cparse.c 
  lj_lib.c lj_alloc.c lib_aux.c 
  ${LJLIB_SRCS} lib_init.c
  )

#### build targets

add_executable(luajit-buildvm-exe ${BUILDVM_SRCS} )
set_target_properties(luajit-buildvm-exe 
  PROPERTIES 
  COMPILE_FLAGS ${C_FLAGS}
  OUTPUT_NAME "buildvm"
)

add_custom_command( 
  OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/lj_vm.s  
  COMMAND 
  ${CMAKE_CURRENT_BINARY_DIR}/buildvm -m ${LJVM_MODE} -o lj_vm.s
  WORKING_DIRECTORY
  ${CMAKE_CURRENT_SOURCE_DIR}
  DEPENDS ${LJLIB_SRCS}
)

add_custom_command(
  OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/lj_bcdef.h  
  COMMAND 
  ${CMAKE_CURRENT_BINARY_DIR}/buildvm -m bcdef -o lj_bcdef.h ${LJLIB_SRCS}
  WORKING_DIRECTORY
  ${CMAKE_CURRENT_SOURCE_DIR}
  DEPENDS ${LJLIB_SRCS}
)

add_custom_command(
  OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/lj_ffdef.h  
  COMMAND 
  ${CMAKE_CURRENT_BINARY_DIR}/buildvm -m ffdef -o lj_ffdef.h ${LJLIB_SRCS}
  WORKING_DIRECTORY
  ${CMAKE_CURRENT_SOURCE_DIR}
  DEPENDS ${LJLIB_SRCS}
)

add_custom_command(
  OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/lj_libdef.h  
  COMMAND 
  ${CMAKE_CURRENT_BINARY_DIR}/buildvm -m libdef -o lj_libdef.h ${LJLIB_SRCS}
  WORKING_DIRECTORY
  ${CMAKE_CURRENT_SOURCE_DIR}
  DEPENDS
  ${LJLIB_SRCS}
)

add_custom_command(
  OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/lj_recdef.h  
  COMMAND 
  ${CMAKE_CURRENT_BINARY_DIR}/buildvm -m recdef -o lj_recdef.h ${LJLIB_SRCS}
  WORKING_DIRECTORY
  ${CMAKE_CURRENT_SOURCE_DIR}
  DEPENDS
  ${LJLIB_SRCS}
)

add_custom_command(
  OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/vmdef.lua 
  COMMAND 
  ${CMAKE_CURRENT_BINARY_DIR}/buildvm -m vmdef -o vmdef.lua ${LJLIB_SRCS}
  WORKING_DIRECTORY
  ${CMAKE_CURRENT_SOURCE_DIR}
  DEPENDS
  ${LJLIB_SRCS}
)

add_custom_command(
  OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/lj_folddef.h 
  COMMAND 
  ${CMAKE_CURRENT_BINARY_DIR}/buildvm -m folddef -o lj_folddef.h lj_opt_fold.c
  WORKING_DIRECTORY
  ${CMAKE_CURRENT_SOURCE_DIR}
  DEPENDS
  ${CMAKE_CURRENT_SOURCE_DIR}/lj_opt_fold.c
) 
 
add_custom_target(luajit-gen-files
  DEPENDS
  ${GEN_SRCS}
  WORKING_DIRECTORY
  ${CMAKE_CURRENT_SOURCE_DIR}
)

set_source_files_properties(${GEN_SRCS}
  PROPERTIES GENERATED TRUE)


if ( LIBRARIES ) 

  add_library(luajit-dll SHARED ${LJVM_SRCS} ${LJCORE_SRCS})
  add_dependencies(luajit-dll luajit-gen-files)
  set_source_files_properties( ${LJCORE_SRCS}
    PROPERTIES 
    LINK_FLAGS "${LD_FLAGS}"
    COMPILE_FLAGS "${C_FLAGS}"
    )
  set_target_properties(luajit-dll
    PROPERTIES 
    OUTPUT_NAME luajit
    )

endif()

if ( ARCHIVES ) 

  add_library(luajit-lib STATIC ${LJVM_SRCS} ${LJCORE_SRCS})
  add_dependencies(luajit-lib luajit-gen-files)
  set_source_files_properties( ${LJCORE_SRCS}
    PROPERTIES 
    LINK_FLAGS "${LD_FLAGS}"
    COMPILE_FLAGS "${C_FLAGS}"
    )
  set_target_properties(luajit-lib
    PROPERTIES 
    OUTPUT_NAME luajit
  )

endif()

if ( EXECUTABLES )

  add_executable(luajit-exe luajit.c )
  add_dependencies(luajit-exe luajit-gen-files)
  set_target_properties(luajit-exe
    PROPERTIES 
    LINK_FLAGS "${LD_FLAGS}"
    COMPILE_FLAGS "${C_FLAGS}"
    OUTPUT_NAME luajit
    )
  target_link_libraries(luajit-exe luajit-lib ${LD_LIBS})

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
    install(FILES ${HEADERS} DESTINATION ${INSTALL_DIR_INCLUDE}/luajit2.0 )
  endif()
  
endif()