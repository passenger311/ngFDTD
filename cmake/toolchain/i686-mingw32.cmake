# ---- system/compiler settings

set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_C_COMPILER i686-w64-mingw32-gcc)
set(CMAKE_CXX_COMPILER i686-w64-mingw32-g++)
set(CMAKE_Fortran_COMPILER i686-w64-mingw32-gfortran)
set(CMAKE_RC_COMPILER i686-w64-mingw32-windres)

# ---- find root path

set(CMAKE_FIND_ROOT_PATH  /usr/i686-w64-mingw32)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# ---- platform flags

set(CPU_TYPE generic) # core2, pentium4, generic (see mtune option)
set(CPU_CORES 1)
set(CPU_ARCH 32)
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

#set(FLAGS_REL "-march=i686 -mtune=${CPU_TUNE} -Wall" )
#set(FLAGS_DBG "-g" )
#set(FLAGS_OMP "-fopenmp")

#set(FLAGS_OPT0 "-O0")
#set(FLAGS_OPT1 "-O1")
#set(FLAGS_OPT2 "-O2 -fomit-frame-pointer")

