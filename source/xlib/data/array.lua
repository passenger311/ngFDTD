local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.data.array",
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
local _require = require 
local _math = math

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> Array. </p>
-- </p>
module( _H.FILE )
-------------------------------------------------------------------------------

local parent = xlib.data.memblock 
local this = proto.clone( _M, parent )

--- Create array.
-- @param ctype C-type of array ("double")
-- @param size size of arrays
-- @return new array
function new(ctype,size)
   local self = parent.new(ctype,size)
   return proto.clone(self, this)
end 


proto.seal(this)

-------------------------------------------------------------------------------
