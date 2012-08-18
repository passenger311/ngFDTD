local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.data.array",
VERSION   = "0.2",
DATE      = "17/08/2012 16:42",
COPYRIGHT = "(C) 2012",
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
--- <p><b>Prototype:</b> array. </p>
-- </p>
module("xlib.data.array")
-------------------------------------------------------------------------------

local this = xlib.data.memblock:adopt( _M )

--- Create array.
-- @param ctype C-type of array ("double")
-- @param size size of arrays
-- @return new array
function new(ctype,size)
   local self = this:parent().new(ctype,size)
   return this:adopt(self)
end 


this:seal()


-------------------------------------------------------------------------------
