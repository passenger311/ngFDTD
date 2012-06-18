#### -*- cmake -*- 
##
## distclean
##
## used by distclean target to clear build and install directories
##
## TODO: recurse into sub-directories and clear all build dirs


cmake_minimum_required(VERSION 2.8)

message("-> distclean: ${PROJECT_HOME}")

function(clear_directory_content DIR)
  file(GLOB FILES ${DIR}/*)
  foreach(F ${FILES})
    file(REMOVE_RECURSE ${F})
  endforeach()
endfunction()

function(recurse_distclean DIR)
  file(GLOB ENTRIES ${DIR}/*)
  foreach(ENTRY ${ENTRIES})
    if ( EXISTS "${ENTRY}/" )
      recurse_distclean(${ENTRY})
      get_filename_component(NAME ${ENTRY} NAME)
      if( ${NAME} STREQUAL "build" )
	message("remove ${ENTRY}/*")
	#execute_process(COMMAND ${CMAKE_COMMAND} -E ${MAKE} clean
        #  WORKING_DIRECTORY ${ENTRY} )
	clear_directory_content(${ENTRY})
      endif()
    endif()
  endforeach()

endfunction()

recurse_distclean(${PROJECT_HOME})
file(REMOVE_RECURSE ${PROJECT_HOME}/INSTALL)
