local _H = {
-------------------------------------------------------------------------------
FILE      = "fdtd.material",
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
local _pairs = pairs
local _insert, _concat = table.insert, table.concat

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> A material consists of (named) parameters and a list 
-- of response models that will be superimposed.
-- </p>
module( _H.FILE )
-------------------------------------------------------------------------------

local this = proto.clone( _M, proto.root )

--- Create new material.
-- @param props named parameters + list of models
-- @return material 
function new( props )
   _assert( _type(props) == "table",
	    "arg1 (props) must be a 'table'" )
   for i=1,#props do
      _assert( props[i]:isa(fdtd.types.model.response),
	       "arg2[i] (props) must be of type 'fdtd.types.model.response'")
   end
   local self = proto.clone( props, this )
   return self
end

--- Stringify material.
-- @param self material
-- @return string
function stringify(self)
   local stab = {} 
   _insert(stab, _H.FILE..".new{\n")
   for k,v in _pairs(self) do
      if _type(k) == "string" and _type(v) == "number" then
	 _insert(stab, "\t"..k.."=".._tostring(v)..",\n")
      end
   end
   for i=1, #self do
      _insert(stab, "\t"..self[i]:stringify()..",\n")
   end
   _insert(stab, "nil }\n")
end

proto.seal(this)

-------------------------------------------------------------------------------
