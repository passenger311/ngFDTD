
ffi = require "ffi"
args = args or { [0]="unknown" }

mpi = ffi.load("mpi", true)
print(mpi)

ffi.cdef[[
      
      int MPI_Init(int* argcp, char*** argvp);
      int MPI_Finalize();
]]

local argc = #args+1
local argv = ffi.new("char *[?]", argc+1)
for i=0,argc-1 do
   argv[i] = ffi.new("char[?]", #args[i]+1, args[i])
end
argv[argc] = ffi.cast("char*", 0)
print("argc = ",argc)
print("argv[0] = ",ffi.string(argv[0]))
print("argv[1] = ",argv[1])
local argcp = ffi.new("int[1]",  argc )
local argvp = ffi.new("char **[1]",  argv )

print(mpi.MPI_Init(argcp,argvp))
mpi.MPI_Finalize();