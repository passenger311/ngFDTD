local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib",
VERSION   = "0.1",
DATE      = "17/08/2012 16:29",
COPYRIGHT = "(C) 2012",
-------------------------------------------------------------------------------
}

local _G = _G
local module = require( "xlib.module" )

-------------------------------------------------------------------------------
---<p><b>Module</b>: Main module. </p>
-- </p>
-- @class module
-- @name xlib
module( "xlib" )
-------------------------------------------------------------------------------

module.imports{
   "lib",
   "utils",
   "module",
   "proto",
   "math",
   "data"
}


-------------------------------------------------------------------------------

--- Project signature.
signature = _H

-------------------------------------------------------------------------------
