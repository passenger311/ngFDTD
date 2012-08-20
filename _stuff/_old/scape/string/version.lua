local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "31/08/2011 12:21",
COPYRIGHT = "GPL V2",
FILE      = "scape.string.version",
-------------------------------------------------------------------------------
}
        
local L = require( _H.PROJECT )
local module = L.module

-------------------------------------------------------------------------------

local _G, _assert, _table, _string, _ipairs, _print
   =  _G, assert, table, string, ipairs, print

-------------------------------------------------------------------------------
--- <p><b>Module:</b> handle version strings.
-- </p>
--
module("scape.string.version")
------------------------------------------------------------------------------

--- Create version number from version string.
-- @param ver version string in format xx[.yy[.zz[.ww]]]
-- @return version number
function tonumber(ver)
   if _type(ver) == 'number' then return ver end
   local base = 1000
   local version = 0
   local nums = {}
   ver = ver:sub(ver:find("%d[%d%.]*"))
   for v in ver:gmatch("[^%.]+") do _table.insert(nums,1,v) end
   _assert(#nums <= 4, "version number has more than 4 digits!")
   for i=#nums,3 do _table.insert(nums,1,0) end
   for i,v in _ipairs(nums) do version = version + v*base^(i-1) end
   return version
end

--- Return lua interpreter version number.
-- @return version number
function lua()
   return tonumber(_G._VERSION)
end

--- Check whether Lua version number is within given range.
-- @param ver version string or number
-- @param vermin minimum version string or number
-- @param vermax maximum version string or number
-- @return <tt>true</i> if within range; <tt>false</tt> otherwise
function inrange(vermin, vermax)
   ver = tonumber(ver)
   return ver >= tonumber(vermin) and ver <= tonumber(vermax)
end

------------------------------------------------------------------------------
