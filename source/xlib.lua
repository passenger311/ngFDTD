local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib",
VERSION   = "0.1",
DATE      = "18/08/2012 16:09",
COPYRIGHT = "(C) 2012 NEO·LIGHT Project",
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
   "types",
   "math",
   "data",
   "unit"
}


-------------------------------------------------------------------------------

--- Project signature.
signature = _H

-------------------------------------------------------------------------------
