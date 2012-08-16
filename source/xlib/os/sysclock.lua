local _H = {
-------------------------------------------------------------------------------
PROJECT   = "xlib",
AUTHOR    = "J Hamm",
VERSION   = "0.2",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2",
FILE      = "xlib.os.sysclock",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local core = module.load("xlib.core")

-------------------------------------------------------------------------------

local _G, string, table, pairs, ipairs, io, tostring, type, require
   =  _G, string, table, pairs, ipairs, io, tostring, type, require
local _floor = math.floor

-------------------------------------------------------------------------------
--- <p><b>Module:</b> Clock functions. 
-- </p>
--
module( "xlib.os.sysclock" )
------------------------------------------------------------------------------


--- Get time in seconds.
-- @return time in seconds
function time()
   return core.sysclock_gettime()
end

--- Get clock resolution.
-- @return clock resolution
function resolution()
   return core.sysclock_resolution()
end

--- Get clock frequency.
-- @return ticks per second
function frequency()
   return 1/resolution()
end

--- Time difference between two time() calls.
-- @return time span in seconds.
function luatick()
   return -(time()-time())
end

--- Time difference between two system clock queries on c-level.
-- @return time span in seconds.
function ctick()
   return core.sysclock_ctick()
end

--- Clock seed function. 
-- @return integer that is nanosecond part of clock
function seed()
   local t = time()/10 -- seconds
   return _floor( ( t-_floor(t) )*1.e9 ) 
end



------------------------------------------------------------------------------

