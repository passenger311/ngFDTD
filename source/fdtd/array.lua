local _H = {
-------------------------------------------------------------------------------
FILE      = "fdtd.array",
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
local _table_insert, _table_concat, _table_remove, _table_maxn 
   = table.insert, table.concat, table.remove, table.maxn
local _assert, _require, _type = assert, require, type
local _math_max, _print = math.max, print
local _rawget = rawget

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> array. </p>
-- </p>
module("fdtd.array")
-------------------------------------------------------------------------------

-- array is now in xlib.data.array

this = proto:adopt( _M )


this:seal()


-------------------------------------------------------------------------------
