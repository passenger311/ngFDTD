local _H = {
-------------------------------------------------------------------------------
PROJECT   = "xlib",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "14/08/2012 16:01",
COPYRIGHT = "GPL V2",
FILE      = "xlib.struct",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local proto = L.proto

-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
--- <p><b>Module:</b> struct library. </p>
--
module( "xlib.struct" )
-------------------------------------------------------------------------------

module.imports{ 
   "set",
   "bag",
   "deque"
}

-------------------------------------------------------------------------------