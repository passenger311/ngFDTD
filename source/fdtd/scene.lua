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

-------------------------------------------------------------------------------

local _tostring, _type, _assert = tostring, type, assert
local _insert, _concat = table.insert, table.concat

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> A scene is a collection of shapes with material ids.
-- </p>
module( _H.FILE )
-------------------------------------------------------------------------------

local this = proto.clone( _M, proto.root )

--- Create new scene from a list
-- @param list list of ( shape, material ) pairs
-- @return scene
function new( list )
   local self = proto.clone( 
      { list = { {}, {} }, shapeidx = {}, matidx = {} },
      this )
   if list then
      self:_init(list)
   end
   return self
end

local function _init(self, list)
   _assert( _type(list) == "table",
	    "arg2 (list) must be a 'table'" )
   local pair
   for i=1, #list do
      pair = list[i]
      self:add(pair[1], pair[2])
   end
end

local function _setindex(index, obj)
   if not index[obj] then
      _insert(index, obj)
      index[obj] = #index
   end
   return index[obj]
end

--- Add shape with given material to scene.
-- @param self self
-- @param shape shape
-- @param mat material
-- @return self
function add(self, shape, mat)
   _assert( shape:isa(fdtd.shape.any),
	    "arg2 (shape) must be of type fdtd.shape.any" )
   _assert( mat:isa(fdtd.material) or _type(mat)=="number", 
	    "arg3 (mat) must be a number or of type fdtd.material" )
   _insert(self.list[1], _setindex(self.shapeidx,shape) )   
   _insert(self.list[2], _setindex(self.matidx,mat) )   
   return self
end

function count(self) 
   return #self.list[1]
end


function stringify(self)
   local stab = {}
   local str
   local midx = self.matidx
   local sidx = self.shapeidx
   local sl = self.list[1]
   local ml = self.list[2]
   for i=1, #midx do
      str = "local mat".._tostring(i).." = "..midx[i]:stringify().."\n"
      _insert(stab, str)
   end
   for i= 1, #sidx do      
      str = "local shape".._tostring(i).." = "..sidx[i]:stringify().."\n"
      _insert(stab, str)
   end
   _insert(stab, _H.FILE..".new{\n")
   for i= 1, #sl do  
      str = "\t{ shape".._tostring(sl[i])..", mat".._tostring(ml[i]).." },"
      _insert(stab,str)
   end
   _insert(stab, "nil }\n")
   return _concat(stab)
end 

proto.seal(this)

-------------------------------------------------------------------------------
