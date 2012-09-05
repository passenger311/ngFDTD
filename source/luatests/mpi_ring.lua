
local ffi = require "ffi"
local xlib = require "xlib"
local mpi = xlib.comms.mpi
local types = xlib.types

assert(mpi.bind(),"could not bind; run with mpirun?") -- dynamically bind to openmpi

mpi.init()

local rank = mpi.comm_rank(mpi.MPI_COMM_WORLD)
local size = mpi.comm_size(mpi.MPI_COMM_WORLD)
local msgsize = 1
local tag1, tag2 = 1,2 
local stats = mpi.create_status_array(4)
local requests = mpi.create_request_array(4)

for i=1, 8 do

   local inmsg = { 
      types.newptr("char", msgsize), 
      types.newptr("char", msgsize) }
   local outmsg = { 
      types.newptr("char", msgsize), 
      types.newptr("char", msgsize) }

   wtime = mpi.wtime()

   prev = rank - 1
   next = rank + 1
   if rank == 0 then prev = size - 1 end
   if rank == size - 1 then next = 0 end

   mpi.irecv(inmsg[1],msgsize,prev,tag1, mpi.MPI_COMM_WORLD, requests)
   mpi.irecv(inmsg[2],msgsize,next,tag2, mpi.MPI_COMM_WORLD, requests+1)

   mpi.isend(outmsg[1],msgsize,prev,tag2, mpi.MPI_COMM_WORLD, requests+2)
   mpi.isend(outmsg[2],msgsize,next,tag1, mpi.MPI_COMM_WORLD, requests+3)

-- do some stuff here

-- complete transactions
   mpi.waitall(4, requests, stats)
   
   if rank == 0 then
      print("sending "..tostring(msgsize).." bytes around in a ring of "..tostring(size).." in "..tostring(mpi.wtime()-wtime).." secs")
   end

   msgsize = msgsize*10

end

mpi.finalize()


