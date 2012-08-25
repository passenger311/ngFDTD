local _H = {
-------------------------------------------------------------------------------
FILE      = "fdtd.models",
VERSION   = "0.1",
DATE      = "18/08/2012 16:09",
COPYRIGHT = "(C) 2012 NEO·LIGHT Project",
-------------------------------------------------------------------------------
}

local xlib = require( "xlib" )
local fdtd = require( "fdtd" )
local module = xlib.module

-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
--- <p><b>Module:</b> Models. </p>
-- </p>
module( _H.FILE )
-------------------------------------------------------------------------------

module.imports{ 
   "basetype",
   "response",
   nil
}


-------------------------------------------------------------------------------
