local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "31/08/2011 12:21",
COPYRIGHT = "GPL V2",
FILE      = "scape.os.info",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local core = module.load("scape.core")

-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
--- <p><b>Module:</b> OS info module. 
-- </p>
--
module( "scape.os.info" )
------------------------------------------------------------------------------

--- OS type.
-- @class field
-- @name type 

--- OS API (POSIX or WIN32).
-- @class field
-- @name api

--- Bit-number of address bus.
-- @class field
-- @name arch

--- Little endian byte ordering
-- @class field
-- @name lendian

type, api, arch, lendian = core.osinfo_getlist()

------------------------------------------------------------------------------

