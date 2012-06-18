## Find package: SuperLU
##
## SUPERLU_INCLUDE_DIR    include file directory
## SUPERLU_LIBRARY_DIR    library file directory
## SUPERLU_LIBRARIES      libraries
## SUPERLU_FOUND          found package?

if (SUPERLU_INCLUDE_DIR AND SUPERLU_LIBRARIES)
  set(SUPERLU_FIND_QUIETLY TRUE)
endif()

find_path(SUPERLU_INCLUDE_DIR
  NAMES
  supermatrix.h
  PATHS
  $ENV{SUPERLU_INCLUDE_DIR}
  ${INCLUDE_INSTALL_DIR}
  PATH_SUFFIXES
  superlu
  )

find_library(SUPERLU_LIBRARIES superlu PATHS $ENV{SUPERLU_LIBRARY_DIR} ${LIB_INSTALL_DIR})

if(SUPERLU_LIBRARIES AND SUPERLU_INCLUDE_DIR)

  get_filename_component(SUPERLU_LIBRARY_DIR ${SUPERLU_LIBRARIES} PATH)
  set(SUPERLU_FOUND TRUE)

else()

  set(SUPERLU_LIBRARIES)
  set(SUPERLU_INCLUDE_DIR)

endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SUPERLU DEFAULT_MSG
                                  SUPERLU_INCLUDE_DIR SUPERLU_LIBRARIES)

mark_as_advanced(SUPERLU_INCLUDE_DIR SUPERLU_LIBRARIES)
