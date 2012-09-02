ffi = require "ffi"

ffi.cdef[[
      int MPI_Init(int* argc, char*** argv);
      int MPI_Finalize();
]]

local mpi = ffi.load("mpi")

do
   local name = arg[0]
   local arg0 = ffi.new("char[?]", #name+1, name)
--   local argv = ffi.new("char *[2]", { arg0, ffi.cast("char*",0)})
   local argv = ffi.new("char *[1]", arg0)
   local argcp = ffi.new("int[1]", 1)
   local argvp = ffi.new("char **[1]", argv)
   mpi.MPI_Init(argcp,argvp);
end


mpi.MPI_Finalize();