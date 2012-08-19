local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.data.memblock",
VERSION   = "0.1",
DATE      = "18/08/2012 16:09",
COPYRIGHT = "(C) 2012 NEO·LIGHT Project",
-------------------------------------------------------------------------------
}

local _G = _G
local ffi = require "ffi"
local xlib = require( "xlib" )
local module = xlib.module
local proto = xlib.proto

-------------------------------------------------------------------------------

local _proto_adopt = proto.adopt
local _pairs, _ipairs, _next, _tostring = pairs, ipairs, next, tostring
local _assert, _require, _type = assert, require, type
local _math = math

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> Memory block (requires ffi). </p>
-- </p>
module("xlib.data.memblock")
-------------------------------------------------------------------------------

ffi.cdef[[
void *memmove(void *dest, const void *src, size_t n);
void *memcpy(void *dest, const void *src, size_t n);
void *malloc(size_t size);
void free(void *ptr);
]]

local this = proto:adopt( _M )

--- Create memblock.
-- @param ctype C-type of memblock ("double")
-- @param size size of memblocks
-- @return new memblock
function new(ctype,size)
   size = size or 0
   local data 
      = ffi.gc(ffi.cast(ctype.." *",ffi.C.malloc(size*ffi.sizeof(ctype))), 
	       ffi.C.free )
   _assert(data ~= nil, "out of memory")
   local ret = this:adopt{ data = data, size = size, ctype=ctype }
   return ret
end 

-- Clear memblock.
-- @param self memblock
-- @return memblock
function clear(self)
   for i=0, self.size-1 do
      self.data[i] = 0
   end
   return self
end

-- Clone memblock
-- @param self memblock
-- @return memblock
function clone(self)
   _assert(self.data ~= nil, "data not allocated!")
   local ret = new(self.ctype,self.size)
   local nbytes = self.size*ffi.sizeof(self.ctype)
   ffi.C.memcpy(ffi.cast("void*",ret.data), ffi.cast("void*", self.data), nbytes)
   return ret
end

-- Save elements to table.
-- @param self memblock
-- @return a item table
function totable(self)
   local tab = {}
   for i=0, self.size-1 do
      tab[i+1] = self.data[i]
   end
   return { self[1], self[2], self[3] }
end

--- Load elements from table. 
-- @param self memblock
-- @param tab item table
-- @return self
function fromtable(self,tab)
   local cnt = self.size
   cnt = _math.min( cnt, #tab ) 
   for i=0, cnt-1 do
      self.data[i] = tab[i+1]
   end
   return self
end


this:seal():fuse()


-------------------------------------------------------------------------------
