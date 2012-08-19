
NEO-LIGHT PROJECT 
=================

Configuration
-------------

1. setup project components 

   Add/customize extra components. This involves creating/modifying 
   "control.cmake", "find.cmake" and "patch/". Add components to "source/" 
   by modifying the hierarchy of "CMakeLists.txt" files.

2. edit files in "setup/" to customize build process
   
   set project name, version number in "project.cmake". Define compiler flags 
   in "compiler.cmake", install locations in "install.cmake", packaging in 
   "package.cmake", and third party package search locations in "search.cmake". 

3. edit "config.h.in"

   to customize the C/C++ project header.


Setup Project Tree
------------------

The build tree is constructed from components using the require(<component>) 
function which ties components on-demand into the build process. 

In the component directory, the "CONTROL.cmake" file is is processed if present.
If not the directory (containing a "CMakeLists.txt") file is directly added to 
the cmake build process. In "CONTROL.cmake": if BUILD is not "on" the 
"FIND.cmake" script is used to search system for package component. If BUILD 
is "on" and a TARBALL specified, then the tarball will be unpacked, the content
of "PATCH/" (if present) copied into the unpacked source directory and the 
directory added to the cmake build.


Build Instructions
------------------

First build the host tools

    > cd tools/build
    > cmake ..
    > make

To build project, enter a top-level "build" directory

    > cd build

and invoke cmake

    > cmake .. [<options>]       

to configure the build. Consider the following two <options> to specify the 
installation directory and a toolchain file:

    -DPREFIX=<install-prefix> 
    -DCMAKE_TOOLCHAIN_FILE=../cmake/toolchain/<file>

Use

    > make [VERBOSE=1]

to build project and install it with 

    > make install


Packaging
---------

Run

    > cpack [-G <generator>]

from within the "build/" directory. CPack offers a choice of <generator>'s 
 
* TGZ (gzipped compressed tar)
* STGZ (self-extracting gzip compressed tar)
* TBZ2 (bzip2 compressed tar)
* TZ (tar unix compressed)
* ZIP 

or 

* NSIS (nullsoft installer)


Cleanup
-------

To cleanup the build run

    > make clean

from within a "build/" directory or

    > make distclean

to wipe the entiry content of that "build/" directory.


-----------------------------------------------------------------------------
_J Hamm (3/8/2012)_
