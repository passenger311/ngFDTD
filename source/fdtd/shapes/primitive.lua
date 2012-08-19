local _H = {
-------------------------------------------------------------------------------
FILE      = "fdtd.shapes.primitive",
VERSION   = "0.1",
DATE      = "14/08/2012 16:01",
COPYRIGHT = "GPL V2",
-------------------------------------------------------------------------------
}

local xlib = require( "xlib" )
local fdtd = require( "fdtd" )
local module = xlib.module
local proto = xlib.proto
local vec3 = fdtd.math.vec3

-------------------------------------------------------------------------------

local _tostring = tostring

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> Primitive shape. </p>
-- </p>
module("fdtd.shapes.primitive")
-------------------------------------------------------------------------------

this = proto:adopt( _M )

--- Create new primitive.
-- @param tab properties { at=[vec3] }
-- @return primitive
function new(tab)
   tab.at = tab.at or {0,0,0}
   tab.at = vec3:adopt(tab.at)
   return this:adopt(tab)
end

--- Move along vector.
-- @param move vec3 
-- @return self
function move(self,vec)
   self.at = self.at + vec
   return self
end


this:seal()


-------------------------------------------------------------------------------
