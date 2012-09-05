
local ffi = require "ffi"
local xlib = require "xlib"
local mpi = xlib.comms.mpi
local types = xlib.types

assert(mpi.bind()) -- dynamically bind to openmpi

mpi.init()

local rank = mpi.comm_rank(mpi.MPI_COMM_WORLD)
local size = mpi.comm_size(mpi.MPI_COMM_WORLD)
local msgsize = 1
local tag = 1

for i = 1, 10 do

   local inmsg = types.newptr("char", msgsize)
   local outmsg = types.newptr("char", msgsize)

   wtime = mpi.wtime()

   if rank == 0 then
      dest = 1 
      source = 1
      mpi.send(ffi.cast("char*",outmsg),msgsize,dest,tag, mpi.MPI_COMM_WORLD)
      stat = mpi.recv(ffi.cast("char*",inmsg),msgsize,source,tag, mpi.MPI_COMM_WORLD)
      print("ping/pong "..tostring(msgsize).." bytes in "..tostring(mpi.wtime()-wtime).." secs")  
   elseif rank == 1 then
      dest = 0 
      source = 0
      stat = mpi.recv(ffi.cast("char*",inmsg),msgsize,source,tag, mpi.MPI_COMM_WORLD)
      mpi.send(ffi.cast("char*",outmsg),msgsize,dest,tag, mpi.MPI_COMM_WORLD)
   end

   msgsize = msgsize*10

end

mpi.finalize()


