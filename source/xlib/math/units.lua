local _H = {
-------------------------------------------------------------------------------
PROJECT   = "neolib",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "14/08/2012 16:01",
COPYRIGHT = "GPL V2",
FILE      = "neolib.math.units",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local proto = L.proto

-------------------------------------------------------------------------------

local _pairs, _type, _tostring, _loadstring, _getfenv, _setfenv, _tostring 
   = pairs, type, tostring, loadstring, getfenv, setfenv, tostring
local _concat, _insert = table.concat, table.insert

-------------------------------------------------------------------------------
--- <p><b>Module:</b> quantities. </p>
--
module("neolib.math.units")
-------------------------------------------------------------------------------

this = proto:_adopt( _M )

-- SI unit system

_M[1] = 0 -- metre [m]
_M[2] = 0 -- kilogram [kg]
_M[3] = 0 -- second [s]
_M[4] = 0 -- ampere [A]
_M[5] = 0 -- kelvin [K]
_M[6] = 0 -- candela [cd]
_M[7] = 0 -- mole [mol]


--- Create new quantity.
-- @param quantity
-- @return new vector 
function new(unit)
   return this:_adopt( unit )
end

function __eq(a,b)
   return a[1] == b[1] and a[2] == b[2] and a[3] == b[3] and a[4] == b[4]
      and a[5] == b[5] and a[6] == b[6] and a[7] == b[7]
end

function __ne(a,b)
   return not a == b
end

function __add(a,b)
   if a == b then return a end
end

function __sub(a,b)
   if a == b then return a end
end

function __mul(a,b)
   return new{ a[1]+b[1], a[2]+b[2], a[3]+b[3], a[4]+b[4], a[5]+b[5],
	       a[6]+b[6], a[7]+b[7] }
end

function __div(a,b)
   return new{ a[1]-b[1], a[2]-b[2], a[3]-b[3], a[4]-b[4],
		  a[5]-b[5], a[6]-b[6], a[7]-b[7] }
end

function __pow(a,b)
   return new{ a[1]*b, a[2]*b, a[3]*b, a[4]*b, a[5]*b, a[6]*b, a[7]*b }
end

function __unm(a)
   return new{ -a[1], -a[2], -a[3], -a[4], -a[5], -a[6], -a[7] }
end

function sqrt(a)
   return new{ a[1]/2, a[2]/2, a[3]/2, a[4]/2, a[5]/2, a[6]/2, a[7]/2 }   
end

function __tostring(a)
   local str = {}
   local u = { "m", "kg", "s", "A", "K", "cd", "mol" }
   for i = 1, 7 do
      if a[i] ~= 0 then
	 if a[i] == 1 then
	    _insert(str, u[i])
	 else
	    _insert(str, u[i].."^(".._tostring(a[i])..")")
	 end
      end
   end
   return _concat(str,"*")
end

this:_seal()

-------------------------------------------------------------------------------
