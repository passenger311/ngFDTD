local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.tests.data.memblock",
VERSION   = "0.1",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2"
-------------------------------------------------------------------------------
}

local xlib = require( "xlib" )
local unit = xlib.unit
local math = xlib.math
local memblock = xlib.data.memblock

-------------------------------------------------------------------------------

local _pcall, _print, _table, _ipairs = pcall, print, table, ipairs
local _collectgarbage = collectgarbage

-------------------------------------------------------------------------------
module( "xlib.tests.data.memblock" )
-------------------------------------------------------------------------------

this = unit.new(_M, { name = _H.FILE, repetition=10 } )

function setup(self)

end

function refcheck1(self)
   local a = memblock.new("double",10000)
   local b = a
   a = nil
   _collectgarbage()
   for i=0,1000-1 do 
      b.data[i] = 1
   end   
end

function alloc1(self)
   local a
   for i=1,1000 do 
      a = memblock.new("double",10000)
   end
end

function alloc2(self)
   local a = {}
   for i=1,1000 do 
      a[i] = memblock.new("double",10000)
   end
   for i=1,1000 do 
      a[i] = nil
   end
   _collectgarbage()
end

function alloc3(self)
   local a
   for i=1,100 do 
      a = memblock.new("double",10000)
      _collectgarbage()
   end
end

function alloc4(self)
   local a
   for i=1,100 do 
      a = memblock.new("double",1000000)
      _collectgarbage()
   end 
end

function init1(self)
   local a = memblock.new("double",1000000)
   for i = 0, 1000000-1 do
      a.data[i] = 1
   end
end

function copy1(self)
   local a = memblock.new("double",100000)
   for i = 1,10 do
      local b = memblock.new("double",100000)
      for i = 0, 100000-1 do
	 b.data[i] = a.data[i]
      end
   end
end

function clone1(self)
   local a = memblock.new("double",100000)
   for i = 1,10 do
      local b = a:clone()
   end
end

function fibonacci1(self)
   local a = memblock.new("double",1000000)
   a.data[0] = 1
   a.data[1] = 1
   for i = 2, 1000000-1 do
      a.data[i] = a.data[i-1]+a.data[i-2]
   end
end

function clone2(self)
   local a = memblock.new("double",1000000)
   for i = 1, 1000000-1 do
      a.data[i] = a.data[i-1]+a.data[i-2]
   end
   local b = a:clone()
   for i = 0,1000000-1 do
      unit.assert( b.data[i] == a.data[i] )
   end
end


------------------------------------------------------------------------------
