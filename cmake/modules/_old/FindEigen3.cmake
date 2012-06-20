## Find package: Eigen3
##
## EIGEN3_INCLUDE_DIR    include file directory
## EIGEN3_LIBRARIES_DIR  library file directory
## EIGEN3_LIBRARIES      libraries
## EIGEN3_FOUND          found package?

find_path(EIGEN3_INCLUDE_DIR
  NAMES 
  signature_of_eigen3_matrix_library
  PATHS
  ${EIGEN3_INCLUDE_DIR} 
  $ENV{EIGEN3_INCLUDE_DIR} 
  ${CMAKE_INSTALL_PREFIX}/include 
  ${KDE4_INCLUDE_DIR} 
  ${INCLUDE_INSTALL_DIR}
  PATH_SUFFIXES
  eigen3 eigen
  )

if( EIGEN3_INCLUDE_DIR)
  set(EIGEN3_FOUND TRUE)
endif()

if( EIGEN3_FOUND )
  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(EIGEN3 DEFAULT_MSG
    EIGEN3_INCLUDE_DIR)
  
  mark_as_advanced(EIGEN3_INCLUDE_DIR)
endif()
