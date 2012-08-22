local _H = {
-------------------------------------------------------------------------------
FILE      = "fabian.tests",
VERSION   = "0.1",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2",
-------------------------------------------------------------------------------
}
 
local xlib = require( "xlib" )
local module = xlib.module
local unit = xlib.unit

-------------------------------------------------------------------------------

local _G, _print = _G, print

-------------------------------------------------------------------------------
module( "fabian.tests" )
-------------------------------------------------------------------------------

local this = unit.new(_M, { name = "all", repetition=1 } )

local prefix = "fabian.tests"

function math(self)
   return self:launch{ 
      prefix..".math.complex"
   }
end

function data(self)
   return self:launch{ 
      prefix..".data.memblock"
--      prefix..".data.array"
   }
end


------------------------------------------------------------------------------
