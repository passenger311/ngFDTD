SYPNOSIS

LuaScape is a protable library providing standard components such as container
classes, extended math, string and stream handling. LuaScape is organized in
a hierachy of modules and uses a mix of functional and prototyped elements.
LuaScape aims for a minimal memory/cpu footprint with both Lua and LuaJIT.

DESIGN

LuaScape itself adopts a high-level approach using native lua code whenever
possible. It integrates third party "backend modules" for extended 
functionality. Depending on the loaded module or invoked function LuaScape 
will attempt to load modules "on-demand".

- granular design
- optimized for both Lua and LuaJIT
- collections of utility functions
- slick prototyping with no significant overheads
- optional building blocks for classes 
- integrated unit testsuite

DEPENDENCIES

- LuaSocket
- LuaFilesystem
- LuaExpat
- LuaSql

Functions (or modules), which rely on these libraries may fail with an 
appropriate message if the backend module is missing.

CONVENTIONS

1) Portable code, binding to backend modules where necessary

LuaScape is largely written in native Lua code, offering a high level of
portability. While most of LuaScape's modules and functions require 
nothing but a Lua (or LuaJIT) interpreter, there are subsets, which make use 
of third-party cross-platform (backend) binary libraries.

2) Extensible framework of modules aiming for universal application 

LuaScape's library structure is a (shallow) tree of modules which can be 
"loaded-on-demand". Its scalable design allows LuaScape to eventually
grow into a large, extensive library for application building.

3) High-quality tested code using integrated unit-testing system.

LuaScape provides a unit testing framework (test.unit), that is used to
test LuaScape's own code. Running "run_tests.lua" will perform all library
tests.

4) Performance optimized with full LuaJIT support  

LuaScape uses code structures which perform well with Lua and with LuaJIT. 
When running with LuaJIT it uses (where benefitial) LuaJIT's  FFI to bind to 
binary core-functions offering improved performance.

5) Tight implementation using modules, prototypes and functions.

A combination of lightweight functional and prototype based programming is 
preferred. Modules are used to group the various components. 
LuaScape also provides a full features class system. LuaScape class objects 
are an extension LuaScape  prototypes and are designed to support both dynamic 
or static dispatch and multiple inheritance.

6) Integrated or global deployment

LuaScape can be integrated into any application by first running 
"make_core.lua" to build the (optional) binary core, "make_doc.lua" to 
build the documentation, and "run_tests.lua" with the Lua/LuaJIT interpreter 
to verify that everything is in full working state. The "scape" 
directory can be either moved into the application directory or to a 
global location.

7) Configurability

Certain aspects of the LuaScape library, such as namespace or the use 
of LuaJITs FFI facility, can be enforced by modifying the "scape/config.lua" 
configuration table. 