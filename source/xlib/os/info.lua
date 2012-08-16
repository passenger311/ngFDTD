local _H = {
-------------------------------------------------------------------------------
PROJECT   = "neolib",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "14/08/2012 16:01",
COPYRIGHT = "GPL V2",
FILE      = "neolib.os.info",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local core = module.load("neolib.core")

-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
--- <p><b>Module:</b> OS info module. 
-- </p>
--
module( "neolib.os.info" )
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

