
mpi = require "xlib.comms.mpi"

assert(mpi.bind("openmpi")) -- dynamically bind to openmpi

local wtime = mpi.wtime()
local major, minor = mpi.get_version()

assert(mpi.init())
assert(mpi.initialized())

local procname = mpi.get_processor_name()
local rank = mpi.comm_rank(mpi.MPI_COMM_WORLD)
local size = mpi.comm_size(mpi.MPI_COMM_WORLD)


if rank == 0 then
   print("mpi version = "..tostring(major).."."..tostring(minor))
end

for i=0,size-1 do
   mpi.barrier(mpi.MPI_COMM_WORLD)
   if rank == i then
      print("rank/size = "..tostring(rank).."/"..tostring(size).." alive on "..procname.." for "..tostring(mpi.wtime()-wtime).." secs")  
   end
end

assert(mpi.finalize())
assert(mpi.finalized())


