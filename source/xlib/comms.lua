local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.comms",
VERSION   = "0.1",
DATE      = "18/08/2012 16:09",
COPYRIGHT = "(C) 2012 NEO·LIGHT Project",
-------------------------------------------------------------------------------
}


local xlib = require( "xlib" )
local module = xlib.module

-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
--- <p><b>Module:</b> Communication modules. </p>
--
module( _H.FILE )
------------------------------------------------------------------------------

module.imports{ 
   "mpi",
   nil
}

------------------------------------------------------------------------------



------------------------------------------------------------------------------
