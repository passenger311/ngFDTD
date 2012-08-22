local _H = {
-------------------------------------------------------------------------------
FILE      = "fdtd.scene",
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
--- <p><b>Prototype:</b> A scene is a collection of shapes with material ids.-- </p>
module("fdtd.scene")
-------------------------------------------------------------------------------

local this = proto:adopt( _M )

--- Create new scene.
-- @return scene
function new()
   local self = {
      mathash = {} -- shapes by matid
      shapelist = {} -- collection of all shapes
      matid = {}
   }
   return this:adopt(self)
end

--- Add shape to scene.
-- @param self self
-- @param shape shape
-- @param matid material id
-- @return self
function add(self,shape, matid)
   _insert(self.shapelist, shape)
   self.matid[shape] = matid
   if not self.mathash[matid] then
      self.mathash[matid] = {}
   end
   _insert(self.mathash[matid], shape)
   return self
end





this:seal():fuse()

-------------------------------------------------------------------------------
