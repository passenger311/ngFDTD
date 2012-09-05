local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.types",
VERSION   = "0.1",
DATE      = "18/08/2012 16:09",
COPYRIGHT = "(C) 2012 NEO·LIGHT Project",
-------------------------------------------------------------------------------
}

local _G = _G
local ffi = require( "ffi" )
local xlib = require( "xlib" )
local module = xlib.module
local proto = xlib.proto

-------------------------------------------------------------------------------

local _tostring, _tonumber, _print = tostring, tonumber, print
local _type, _assert = type, assert

-------------------------------------------------------------------------------
--- <p><b>Module:</b> Type arithmetic (requires ffi). </p>
--
module( _H.FILE )
-------------------------------------------------------------------------------

module.imports{ 
}

ffi.cdef[[
void *malloc(size_t size);
void free(void *ptr);
]]

-- basetypes known to LuaJITs ffi

bool = ffi.typeof("bool")
char = ffi.typeof("char")

short_int = ffi.typeof("short int")
unsigned_short_int = ffi.typeof("unsigned short int")
int = ffi.typeof("int")
unsigned_int = ffi.typeof("unsigned int")
long_int = ffi.typeof("long int")
unsigned_long_int = ffi.typeof("unsigned long int")
int8_t = ffi.typeof("int8_t")
int16_t = ffi.typeof("int16_t")
int32_t = ffi.typeof("int32_t")
int64_t = ffi.typeof("int64_t")
uint8_t = ffi.typeof("uint8_t")
uint16_t = ffi.typeof("uint16_t")
uint32_t = ffi.typeof("uint32_t")
uint64_t = ffi.typeof("uint64_t")

float = ffi.typeof("float")
double = ffi.typeof("double")
complex_float = ffi.typeof("complex float")
complex_double = ffi.typeof("complex double")

function info( type )
   local tstr = _tostring(ffi.typeof(type))   
   local ts, ps = tstr:match("ctype<(%S+)%s*(.*)>")
   return ts, ps
end

function isptr( type )
   local ts,ps = info(type)
   return ps == "*"   
end

new = ffi.new

--[[
-- it would be nice to keep track of the allocated size, but this somehow
-- makes things very slow.
local __allocsize = {}

function allocsize(obj)
   return __allocsize[obj]
end

local function free(obj)  -- to be called by ffi.gc collector
   __allocsize[obj] = nil
   ffi.C.free(obj)
end
--]]

function newptr(type, nelems)
   local ts, ps = info(type)
   _assert( ps == "", "newptr expects base type" )
   _assert( _type(ts) == "string" )
   local ptr
   if nelems then
      ptr = ffi.gc(ffi.cast(ts.." *",ffi.C.malloc(nelems*ffi.sizeof(type))), 
		   ffi.C.free )
      _assert(ptr ~= nil, "out of memory")
--    __allocsize[ptr]=nelems -- register size info
   else
      ptr = ffi.new(ts.." *")
   end
   return ptr
end


-------------------------------------------------------------------------------
