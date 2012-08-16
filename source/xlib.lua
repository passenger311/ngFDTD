local _H = {
-------------------------------------------------------------------------------
PROJECT   = "xlib",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "14/08/2012 16:01",
COPYRIGHT = "GPL V2",
FILE      = "xlib",
-------------------------------------------------------------------------------
}

local _G = _G
local module = require( _H.PROJECT..".module" )

-------------------------------------------------------------------------------
---<p><b>Module</b>: Main module. </p>
-- </p>
-- @class module
-- @name xlib
module( "xlib" )
-------------------------------------------------------------------------------

module.imports{
   "config",
   "utils",
   "module",
   "object",
   "proto",
   "class",
   "math",
   "file",
   "io",
   "string",
   "table",
   "struct",
   "os",
   "table",
   "string",
   "debug",
   "coroutine",
   "unit"
}

_G.xlib = _M

-------------------------------------------------------------------------------

--- Project signature.
signature = _H

-------------------------------------------------------------------------------
