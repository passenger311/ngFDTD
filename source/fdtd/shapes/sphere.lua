local _H = {
-------------------------------------------------------------------------------
FILE      = "fdtd.shapes.sphere",
VERSION   = "0.1",
DATE      = "14/08/2012 16:01",
COPYRIGHT = "GPL V2",
-------------------------------------------------------------------------------
}

local xlib = require( "xlib" )
local fdtd = require( "fdtd" )
local module = xlib.module
local proto = xlib.proto

-------------------------------------------------------------------------------

local _tostring, _assert, _type = tostring, assert, type

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> Sphere primitive. </p>
-- </p>
module("fdtd.shapes.sphere")
-------------------------------------------------------------------------------

this = fdtd.shapes.primitive:adopt( _M )

--- Create and initialize with table.
-- @param tab properties { at=[vec3], r=[number] }
-- @return new shape
function new(tab)
   local ret = this:pnew( tab )
   tab.r = tab.r or 1
   _assert( _type(tab.r)=='number', "expects r=[number]" ) 
   return ret
end

--- Check whether point is inside object.
-- @param self shape
-- @return <tt>true</tt> or <tt>false</tt>
function contains(self, point)
   local at, r = self.at, self.r
   local d1 = at[1]-point[1]
   local d2 = at[2]-point[2]
   local d3 = at[3]-point[3]
   return d1*d1+d2*d2+d3*d3 <= r*r
end

--function frame(self, point)


--- Serialize in a string.
-- @param self vector
-- @return string 
function serialize(self)
   return _H.FILE.."{ at=".._tostring(self.at)..", r=".._tostring(self.r).." }"
end

this:seal():fuse()


-------------------------------------------------------------------------------
