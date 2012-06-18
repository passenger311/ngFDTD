local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2",
FILE      = "tests",
-------------------------------------------------------------------------------
}
 
local L = require( _H.PROJECT )
local module = L.module
local unit = L.unit

-------------------------------------------------------------------------------

local _G, _print = _G, print

-------------------------------------------------------------------------------
module( "scape.tests" )
-------------------------------------------------------------------------------

this = unit.new(_M, { name = "all", repetition=1 } )

local prefix = _H.PROJECT..".".._H.FILE

function class(self)
   return self:launch{ 
      prefix..".class-ordering"
   }
end

function math(self)
   return self:launch{ 
      prefix..".math.complex"
   }
end

function struct(self)
   return self:launch{ 
      prefix..".struct.set"
   }
end

------------------------------------------------------------------------------
