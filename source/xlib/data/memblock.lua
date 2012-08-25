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
local _string_match = string.match
local _print = print
local _math = math

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> Memory block (requires ffi).
-- Note 1: allocate using malloc overcomes LuaJITs 4GB limit
-- Note 2: this is all terribly unsafe and that accessing data outside of
-- the size limit will inevitably result in a segfault!
-- </p>
module( _H.FILE )
-------------------------------------------------------------------------------

--void *memmove(void *dest, const void *src, size_t n);
--void *memcpy(void *dest, const void *src, size_t n);

ffi.cdef[[
void *malloc(size_t size);
void free(void *ptr);
]]

local this = proto.clone( _M, proto.root )

--- Create memblock.
-- @param ctype C-type of memblock ("double")
-- @param size size of memblocks
-- @return new memblock
function new(ctype,size)
   return proto.clone( { data = xlib.types.newptr(ctype, size),
			 _immutable_size = size 
		      }, this ) 
end

-- Clear memblock.
-- @param self memblock
-- @return memblock
function clear(self)
   local nbytes = self:size()*ffi.sizeof(self:type())
   ffi.fill(self.data,nbytes,0)
   return self
end

function size(self)
   return self._immutable_size
--   return xlib.types.allocsize(self.data)
end

function eltype(self)
   local ts, ps = xlib.types.info(self.data)
   return ts
end

-- Fill memblock.
-- @param self memblock
-- @param val fill value
-- @return memblock
function fill(self,val)
   local data = self.data
   for i=0,self:size()-1 do
      data[i] = val
   end
   return self
end

-- Apply function to each element.
-- @param self memblock
-- @param apply function
-- @return memblock
function apply(self,apply)
   local data = self.data
   for i=0,self:size()-1 do
      data[i] = apply(data[i])
   end
   return self
end

-- Clone memblock
-- @param self memblock
-- @return memblock
function clone(self)
   _assert(self.data ~= nil, "data not allocated!")
   local ret = new(self:eltype(),self:size())
   local nbytes = self:size()*ffi.sizeof(self:eltype())
   ffi.copy(ret.data,self.data,nbytes)
--   ffi.C.memcpy(ffi.cast("void*",ret.data), ffi.cast("void*", self.data), nbytes)
   return ret
end

-- Save elements to table.
-- @param self memblock
-- @return a item table
function totable(self)
   local tab = {}
   local data = self.data
   for i=0, self:size()-1 do
      tab[i+1] = data[i]
   end
   return { self[1], self[2], self[3] }
end

--- Load elements from table. 
-- @param self memblock
-- @param tab item table
-- @return self
function fromtable(self,tab)
   local cnt = self:size()
   local data = self.data
   cnt = _math.min( cnt, #tab ) 
   for i=0, cnt-1 do
      data[i] = tab[i+1]
   end
   return self
end

proto.seal(this)

-------------------------------------------------------------------------------
