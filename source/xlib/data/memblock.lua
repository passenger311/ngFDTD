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

local _pairs, _ipairs, _next, _tostring = pairs, ipairs, next, tostring
local _assert, _require, _type = assert, require, type
local _math = math

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> array. </p>
-- </p>
module("xlib.data.memblock")
-------------------------------------------------------------------------------

ffi.cdef[[
void *memmove(void *dest, const void *src, size_t n);
void *malloc(size_t size);
void free(void *ptr);
]]

local this = proto:adopt( _M )

--- Create array.
-- @param ctype C-type of array ("double")
-- @param size size of arrays
-- @return new array
function new(ctype,size)
   size = size or 0
   local data 
      = ffi.gc(ffi.cast(ctype.." *",ffi.C.malloc(size*ffi.sizeof(ctype))), 
	       ffi.C.free )
   _assert(data ~= nil, "out of memory")
   local ret = this:adopt{ data = data, size = size, ctype=ctype }
   return ret
end 

-- Clear array.
-- @param self array
-- @return array
function clear(self)
   for i=0, self.size-1 do
      self.data[i] = 0
   end
   return self
end

-- Save elements to table.
-- @param self array
-- @return a item table
function totable(self)
   local tab = {}
   for i=0, self.size-1 do
      tab[i+1] = self.data[i]
   end
   return { self[1], self[2], self[3] }
end

--- Load elements from table. 
-- @param self array
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


this:seal()


-------------------------------------------------------------------------------
