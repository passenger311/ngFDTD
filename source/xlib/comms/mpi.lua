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
local types = xlib.types

-------------------------------------------------------------------------------

local G = _G
local _assert, _error, _pcall = assert, error, pcall
local _tostring = tostring
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

local known_mpi_flavors = { 
   "openmpi",
--   "lam",
--   "mpich",
--   "mpich2",
--   "mvapich",
--   "",
   nil
}

------------------------------------------------------------------------------


lib = nil         -- handle for libmpi.so (nil if not bound)
flavor = nil      -- MPI flavor ("openmpi", "mpich" ...)
errtab = nil      -- table to associate MPI error codes <-> MPI error symbols
rank = nil        -- rank (comm world size as set in environment)
size = nil        -- size (comm world size as set in environment)

-- detect MPI version
function detect()
   local _flavor = nil
   for i=1,#known_mpi_flavors do
      local k = known_mpi_flavors[i]
      if _M[k].detect(_M) then
	 _flavor = k
	 break
      end
   end
   return _flavor
end

function bind()
   flavor = detect()
   if not flavor then return false end -- could not bind (running serial?)
   _M[flavor].inject(_M)    -- inject flavor specific MPI definitions
   _M.common.inject(_M)     -- inject common MPI definitions
   for k,v in _pairs(errtab) do    -- setup error table
      errtab[v] = k
   end
   return true
end

function abort(comm, errorcode)
   comm = comm or MPI_COMM_WORLD
   errorcode = errorcode or 999
   lib.MPI_Abort(comm, errorcode)
end

function assert(cond) -- user abort
   if cond then
      abort(MPI_COMM_WORLD, 9999)
      _error()
   end
end

local function assertok(errno)
   if errno ~= 0 then
      abort(MPI_COMM_WORLD, errno)
      _error()
   end
   return true
end

local function seterrno(retval)
   errno = retval
end

-- mpi call wrapper
local function mpicall(funstr,...)
   _assert( lib, "not bound to an MPI library")
   local fun = lib["MPI_"..funstr]
   return fun(...)
end


function create_status_array(count)
   return ffi.new("MPI_Status[?]",count)
end

function create_request_array(count)
   return ffi.new("MPI_Request[?]",count)
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
   assertok(mpicall("Init",argcp, arvp))
end

function finalize()
   assertok( mpicall("Finalize") )
end

function comm_size(comm)
   local size = ffi.new("int[1]")
   assertok(mpicall("Comm_size", comm, size))
   return size[0]
end

function comm_rank(comm)
   local rank = ffi.new("int[1]")
   assertok(mpicall("Comm_rank", comm, rank))
   return rank[0]
end

function get_version()
   local major = ffi.new("int[1]")
   local minor = ffi.new("int[1]")
   assertok( mpicall("Get_version", major, minor) )
   return major[0], minor[0]
end

function get_processor_name()
   local name = ffi.new("char[?]", MPI_MAX_PROCESSOR_NAME)
   local length = ffi.new("int[1]")
   assertok(mpicall("Get_processor_name", name, length))
   return ffi.string(name,length[0])
end

function wtime()
   return mpicall("Wtime")
end

function wtick()
   return mpicall("Wtick")
end

function barrier(comm)
   return assertok(mpicall("Barrier", comm))
end

datatype = {

   ["bool"] = "MPI_BOOL",
   ["char"] = "MPI_CHAR",
   ["short"] = "MPI_SHORT",
   ["int"] = "MPI_INT",
   ["int64_t"] = "MPI_LONG",
   ["unsigned char"] = "MPI_CHAR",
   ["unsigned short"] = "MPI_SHORT",
   ["unsigned int"] = "MPI_INT",
   ["uint64_t"] = "MPI_LONG",
   ["float"] = "MPI_FLOAT",
   ["double"] = "MPI_DOUBLE",
   ["long double"] = "MPI_LONG_DOUBLE",
   ["complex float"] = "MPI_C_FLOAT_COMPLEX",
   ["complex"] = "MPI_C_DOUBLE_COMPLEX",

   nil
}

function send(buf, count, dest, tag, comm)
   local t,p = types.info(buf) -- infer datatype for buffer type
   _assert( p == "*", "arg1 (buf) must be a pointer type")
   local dtype = datatype[t]
   _assert( dtype, "buffer has invalid data type")
   return assertok( 
      mpicall("Send",ffi.cast("void *",buf), count, 
	      _M[dtype], dest, tag, comm)

   )
end

function recv(buf, count, source, tag, comm, stat)
   local t,p = types.info(buf) -- infer datatype for buffer type
   _assert( p == "*", "arg1 (buf) must be a pointer type")
   local dtype = datatype[t]
   _assert( dtype, "buffer has invalid data type")
   return assertok( 
      mpicall("Recv",ffi.cast("void *",buf), count, 
	      _M[dtype], source, tag, comm, stat)
   )
end


function isend(buf, count, dest, tag, comm, request)
   local t,p = types.info(buf) -- infer datatype for buffer type
   _assert( p == "*", "arg1 (buf) must be a pointer type")
   local dtype = datatype[t]
   _assert( dtype, "buffer has invalid data type")
   return assertok( 
      mpicall("Isend",ffi.cast("void *",buf), count, 
	      _M[dtype], dest, tag, comm, request)

   )
end

function irecv(buf, count, source, tag, comm, request)
   local t,p = types.info(buf) -- infer datatype for buffer type
   _assert( p == "*", "arg1 (buf) must be a pointer type")
   local dtype = datatype[t]
   _assert( dtype, "buffer has invalid data type")
   local stat = ffi.new("MPI_Status[1]")
   return assertok( 
      mpicall("Irecv",ffi.cast("void *",buf), count, 
	      _M[dtype], source, tag, comm, request)
   )
end

function wait(request, stat)
   return assertok( 
      mpicall("Wait", request, stat)
   )
end

function waitall(count, requests, stats)
   local stats = ffi.new("MPI_Status[?]",count)
   return assertok( 
      mpicall("Waitall",count, requests, stats)
   )
end

------------------------------------------------------------------------------
