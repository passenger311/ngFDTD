## Find package: FFTW
##
## FFTW_INCLUDE_DIR    include file directory
## FFTW_LIBRARY_DIR  library file directory
## FFTW_LIBRARIES      libraries
## FFTW_FOUND          found package?

if (FFTW_INCLUDE_DIR AND FFTW_LIBRARY_DIR)
  set(FFTW_FIND_QUIETLY TRUE)
endif ()


find_path(FFTW_INCLUDE_DIR
  NAMES 
  fftw3.h
  PATHS
  ${FFTW_INCLUDE_DIR} $ENV{FFTW_INCLUDE_DIR} ${INCLUDE_INSTALL_DIR}
  PATH_SUFFIXES
  fftw fftw3
  )

find_library(FFTW_LIB
  NAMES
  fftw3
  PATHS 
  ${FFTW_LIBRARY_DIR} $ENV{FFTW_LIBRARY_DIR} ${LIB_INSTALL_DIR} 
  PATH_SUFFIXES
  fftw fftw3
)

find_library(FFTWF_LIB 
  NAMES
  fftw3f
  PATHS 
  ${FFTW_LIBRARY_DIR} $ENV{FFTW_LIBRARY_DIR} ${LIB_INSTALL_DIR} 
  PATH_SUFFIXES
  fftw fftw3
)

find_library(FFTWL_LIB 
  NAMES
  fftw3l
  PATHS 
  ${FFTW_LIBRARY_DIR} $ENV{FFTW_LIBRARY_DIR} ${LIB_INSTALL_DIR} 
  PATH_SUFFIXES
  fftw fftw3
)

set(FFTW_LIBRARIES "${FFTW_LIB} ${FFTWF_LIB} ${FFTWL_LIB}")

if(FFTW_LIBRARIES AND FFTW_INCLUDE_DIR)

  get_filename_component(FFTW_LIBRARY_DIR ${FFTW_LIB} PATH)
  set(FFTW_FOUND TRUE)

else()

  set(FFTW_LIBRARIES)
  set(FFTW_INCLUDE_DIR)

endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(FFTW DEFAULT_MSG
                                  FFTW_INCLUDE_DIR FFTW_LIBRARIES)

mark_as_advanced(FFTW_INCLUDE_DIR FFTW_LIBRARIES)
