
mpi = require "xlib.comms.mpi"

assert(mpi.bind("openmpi")) -- dynamically bind to openmpi

local major, minor = mpi.get_version()

assert(mpi.init())
assert(mpi.initialized())

local rank = mpi.comm_rank(mpi.MPI_COMM_WORLD)
local size = mpi.comm_size(mpi.MPI_COMM_WORLD)

if rank == 0 then
   print("mpi version = "..tostring(major).."."..tostring(minor))
end

for i=0,size-1 do
   mpi.barrier(mpi.MPI_COMM_WORLD)
   if rank == i then
      print("comm rank/size = "..tostring(rank).."/"..tostring(size).." alive")
   end
end

assert(mpi.finalize())
assert(mpi.finalized())
