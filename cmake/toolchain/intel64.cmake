# ---- system/compiler settings

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_C_COMPILER icc)
set(CMAKE_CXX_COMPILER icpc)
set(CMAKE_Fortran_COMPILER ifort)

# ---- find root path

set(CMAKE_FIND_ROOT_PATH /opt/intel /usr )
#set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
#set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
#set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# ---- platform flags

set(CPU_TUNE core2) #  core2, pentium4, generic (see mtune option)
set(CPU_CORES 2)
set(CPU_ARCH 64)
set(ENABLE_OPENMP 1)
set(HAVE_MPI 1)
set(HAVE_SSE 1)
set(HAVE_SSE2 1)
set(HAVE_SSE3 1)
set(HAVE_SSSE3 1)
set(HAVE_ALTIVEC 0)
set(USE_PREFETCH 1)
set(PREFETCH_AHEAD 10)

# ---- compilation flags

set(FLAGS_REL "-mtune=${CPU_TUNE} -Wall" )
set(FLAGS_DBG "-g" )
set(FLAGS_OMP "-openmp")

set(FLAGS_OPT0 "-O0")
set(FLAGS_OPT1 "-O1")
set(FLAGS_OPT2 "-O2 -fomit-frame-pointer")

