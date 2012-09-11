
local xlib = require "xlib"
local mpi = xlib.comms.mpi

assert(mpi.bind()) -- dynamically bind to mpi

mpi.init()

mpi.finalize()

