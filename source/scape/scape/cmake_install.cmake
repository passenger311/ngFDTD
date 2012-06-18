# Install script for directory: /home/achim/Desktop/Projects/luascape/scape

# Set the install prefix
IF(NOT DEFINED CMAKE_INSTALL_PREFIX)
  SET(CMAKE_INSTALL_PREFIX "/usr/local")
ENDIF(NOT DEFINED CMAKE_INSTALL_PREFIX)
STRING(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
IF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  IF(BUILD_TYPE)
    STRING(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  ELSE(BUILD_TYPE)
    SET(CMAKE_INSTALL_CONFIG_NAME "")
  ENDIF(BUILD_TYPE)
  MESSAGE(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
ENDIF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)

# Set the component getting installed.
IF(NOT CMAKE_INSTALL_COMPONENT)
  IF(COMPONENT)
    MESSAGE(STATUS "Install component: \"${COMPONENT}\"")
    SET(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  ELSE(COMPONENT)
    SET(CMAKE_INSTALL_COMPONENT)
  ENDIF(COMPONENT)
ENDIF(NOT CMAKE_INSTALL_COMPONENT)

# Install shared libraries without execute permission?
IF(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  SET(CMAKE_INSTALL_SO_NO_EXE "1")
ENDIF(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/luascape" TYPE FILE FILES "/home/achim/Desktop/Projects/luascape/scape.lua")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/luascape/scape" TYPE FILE FILES "/home/achim/Desktop/Projects/luascape/scape/README")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/luascape/scape" TYPE FILE FILES
    "/home/achim/Desktop/Projects/luascape/scape/config.lua"
    "/home/achim/Desktop/Projects/luascape/scape/fun.lua"
    "/home/achim/Desktop/Projects/luascape/scape/class.lua"
    "/home/achim/Desktop/Projects/luascape/scape/tests.lua"
    "/home/achim/Desktop/Projects/luascape/scape/table.lua"
    "/home/achim/Desktop/Projects/luascape/scape/proto.lua"
    "/home/achim/Desktop/Projects/luascape/scape/ffi.lua"
    "/home/achim/Desktop/Projects/luascape/scape/coroutine.lua"
    "/home/achim/Desktop/Projects/luascape/scape/os.lua"
    "/home/achim/Desktop/Projects/luascape/scape/lib.lua"
    "/home/achim/Desktop/Projects/luascape/scape/math.lua"
    "/home/achim/Desktop/Projects/luascape/scape/debug.lua"
    "/home/achim/Desktop/Projects/luascape/scape/strict.lua"
    "/home/achim/Desktop/Projects/luascape/scape/log.lua"
    "/home/achim/Desktop/Projects/luascape/scape/string.lua"
    "/home/achim/Desktop/Projects/luascape/scape/io.lua"
    "/home/achim/Desktop/Projects/luascape/scape/unit.lua"
    "/home/achim/Desktop/Projects/luascape/scape/object.lua"
    "/home/achim/Desktop/Projects/luascape/scape/struct.lua"
    "/home/achim/Desktop/Projects/luascape/scape/file.lua"
    "/home/achim/Desktop/Projects/luascape/scape/utils.lua"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/luascape/scape/struct" TYPE FILE FILES
    "/home/achim/Desktop/Projects/luascape/scape/struct/list.lua"
    "/home/achim/Desktop/Projects/luascape/scape/struct/bag.lua"
    "/home/achim/Desktop/Projects/luascape/scape/struct/set.lua"
    "/home/achim/Desktop/Projects/luascape/scape/struct/deque.lua"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/luascape/scape/fun" TYPE FILE FILES
    "/home/achim/Desktop/Projects/luascape/scape/fun/mexpr.lua"
    "/home/achim/Desktop/Projects/luascape/scape/fun/op.lua"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/luascape/scape/tests" TYPE FILE FILES
    "/home/achim/Desktop/Projects/luascape/scape/tests/class-proto.lua"
    "/home/achim/Desktop/Projects/luascape/scape/tests/class-ordering.lua"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/luascape/scape/tests/struct" TYPE FILE FILES "/home/achim/Desktop/Projects/luascape/scape/tests/struct/set.lua")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/luascape/scape/tests/math" TYPE FILE FILES "/home/achim/Desktop/Projects/luascape/scape/tests/math/complex.lua")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/luascape/scape/io" TYPE FILE FILES "/home/achim/Desktop/Projects/luascape/scape/io/fs.lua")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/luascape/scape/collection" TYPE FILE FILES
    "/home/achim/Desktop/Projects/luascape/scape/collection/IGenericSet.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/AVLTree.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/IGenericContainer.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/IGenericQueue.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/ISearchTree.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/IEnumerable.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/FibonacciHeap.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/IGenericStack.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/BinarySearchTree.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/IGenericTree.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/Bits.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/BinaryHeap.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/IGenericQueueOrStack.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/DequeSet.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/IGenericDoubleEndedQueue.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/ISortable.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/List.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/IGenericPriorityQueue.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/NaryTree.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/ListSet.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/Bag.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/Deque.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/ISearchable.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/BinaryTree.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/IReverseEnumerable.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/utils.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/Set.lua"
    "/home/achim/Desktop/Projects/luascape/scape/collection/GeneralTree.lua"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/luascape/scape/table" TYPE FILE FILES
    "/home/achim/Desktop/Projects/luascape/scape/table/.#expr.lua"
    "/home/achim/Desktop/Projects/luascape/scape/table/serialize.lua"
    "/home/achim/Desktop/Projects/luascape/scape/table/.#eval.lua"
    "/home/achim/Desktop/Projects/luascape/scape/table/ostream.lua"
    "/home/achim/Desktop/Projects/luascape/scape/table/expr.lua"
    "/home/achim/Desktop/Projects/luascape/scape/table/istream.lua"
    "/home/achim/Desktop/Projects/luascape/scape/table/eval.lua"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/luascape/scape/string" TYPE FILE FILES
    "/home/achim/Desktop/Projects/luascape/scape/string/encode.lua"
    "/home/achim/Desktop/Projects/luascape/scape/string/stream.lua"
    "/home/achim/Desktop/Projects/luascape/scape/string/ostream.lua"
    "/home/achim/Desktop/Projects/luascape/scape/string/version.lua"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/luascape/scape/os" TYPE FILE FILES
    "/home/achim/Desktop/Projects/luascape/scape/os/sysclock.lua"
    "/home/achim/Desktop/Projects/luascape/scape/os/timer.lua"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/luascape/scape/file" TYPE FILE FILES
    "/home/achim/Desktop/Projects/luascape/scape/file/.#istream.lua"
    "/home/achim/Desktop/Projects/luascape/scape/file/ostream.lua"
    "/home/achim/Desktop/Projects/luascape/scape/file/istream.lua"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/luascape/scape/math" TYPE FILE FILES
    "/home/achim/Desktop/Projects/luascape/scape/math/dists.lua"
    "/home/achim/Desktop/Projects/luascape/scape/math/units.lua"
    "/home/achim/Desktop/Projects/luascape/scape/math/complex.lua"
    "/home/achim/Desktop/Projects/luascape/scape/math/quants.lua"
    "/home/achim/Desktop/Projects/luascape/scape/math/vector.lua"
    "/home/achim/Desktop/Projects/luascape/scape/math/matrix.lua"
    "/home/achim/Desktop/Projects/luascape/scape/math/vec3.lua"
    "/home/achim/Desktop/Projects/luascape/scape/math/consts.lua"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/luascape/scape/math/complex" TYPE FILE FILES
    "/home/achim/Desktop/Projects/luascape/scape/math/complex/ffi.lua"
    "/home/achim/Desktop/Projects/luascape/scape/math/complex/native.lua"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  INCLUDE("/home/achim/Desktop/Projects/luascape/scape/scape/core/cmake_install.cmake")

ENDIF(NOT CMAKE_INSTALL_LOCAL_ONLY)

