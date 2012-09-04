local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.comms.mpi",
VERSION   = "0.1",
DATE      = "18/08/2012 16:09",
COPYRIGHT = "(C) 2012 NEO·LIGHT Project",
-------------------------------------------------------------------------------
}


local ffi = require( "ffi" )
local xlib = require( "xlib" )
local module = xlib.module

-------------------------------------------------------------------------------

local G = _G
local _assert, _error, _pcall = assert, error, pcall
local _pairs = pairs
local _print = print

-------------------------------------------------------------------------------
--- <p><b>Module:</b> MPI communication layer. </p>
--
module( _H.FILE )
------------------------------------------------------------------------------

module.imports{ 
   "openmpi",
   "common",
   nil
}

------------------------------------------------------------------------------


lib = nil         -- handle for libmpi.so (nil if not bound)
flavor = nil      -- MPI flavor ("openmpi", "mpich" ...)
errno = 0         -- last error
errtab = nil      -- table to associate MPI error codes <-> MPI error symbols
profile = false   -- use MPI profiling routines

local known_mpi_flavors = { 
   ["openmpi"]=true, 
   ["mpich"]=false, 
   ["mvapich"]=false,			
   ["lam"]=false,
   nil
}

function bind(_flavor, _profile)
   _flavor = _flavor or "openmpi"
   _assert(known_mpi_flavors[_flavor],"unknown MPI flavor")
   flavor = _flavor
   if _profile then
      profile = true
   else
      profile = false
   end
   errno = 0
   errtab = {}
   _M[flavor].inject(_M) -- load flavor specific defs
   if lib then
      _M.common.inject(_M)
      for k,v in _pairs(errtab) do
	 errtab[v] = k
      end
      return true
   end
end

-- mpi call wrapper
local function mpicall(funstr,...)
   _assert( lib, "not bound to an MPI library")
   local fun
   if profile then
      fun = lib["PMPI_"..funstr]
   else
      fun = lib["MPI_"..funstr]
   end
   errno = fun(...)   -- set errno
   return errno == 0  -- return true if no error occured
end

function initialized()
   local flag = ffi.new("int[1]")
   mpicall("Initialized", flag)
   return flag[0] == 1
end

function finalized()
   local flag = ffi.new("int[1]")
   mpicall("Finalized", flag)
   return flag[0] == 1
end

function init(args)
   _assert( not initialized(), "already initialized")
   -- handle command-line arguments
   args = args or { [0]="unknown" }
   local argc = #args+1
   local argv = ffi.new("char *[?]", argc+1 )
   for i=0,argc-1 do
      argv[i] = ffi.new("char[?]", #args[i]+1, args[i])
   end
   argv[argc] = ffi.cast("char*", 0)
   local argcp = ffi.new("int[1]", argc)
   local argvp = ffi.new("char **[1]", argv)
   return mpicall("Init",argcp, arvp)
end

function finalize()
   _assert( not finalized(), "already finalized")
   return mpicall("Finalize")
end

function abort(comm, errorcode)
   return mpicall("Abort", comm, errorcode)
end

function comm_size(comm)
   _assert( initialized(), "mpi interface not initialized")
   local size = ffi.new("int[1]")
   mpicall("Comm_size", comm, size)
   return size[0]
end

function comm_rank(comm)
   _assert( initialized(), "mpi interface not initialized")
   local rank = ffi.new("int[1]")
   mpicall("Comm_rank", comm, rank)
   return rank[0]
end

function get_version()
   local major = ffi.new("int[1]")
   local minor = ffi.new("int[1]")
   mpicall("Get_version", major, minor)
   return major[0], minor[0]
end

function barrier(comm)
   _assert( initialized(), "mpi interface not initialized")
   return mpicall("Barrier", comm)
end

------------------------------------------------------------------------------
