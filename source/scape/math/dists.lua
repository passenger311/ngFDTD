local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "31/08/2011 12:21",
COPYRIGHT = "GPL V2",
FILE      = "scape.math.dists",
-------------------------------------------------------------------------------
}

-- TODO: multinomial distribution
-- TODO: dirichlet distribution

local L = require( _H.PROJECT )
local module = L.module
local math = L.math

-------------------------------------------------------------------------------

local _pairs, _ipairs, _type, _tostring, _assert, _print
   = pairs, ipairs, type, tostring, assert, print
local _exp, _floor, _pi, _log = math.exp, math.floor, math.pi, math.log
local _factorial, _binomial = math.factorial, math.binomial

-------------------------------------------------------------------------------
--- <p><b>Module:</b> probability distribution functions. </p>
--
module("scape.math.dists")
-------------------------------------------------------------------------------

local sqrt2pi = math.sqrt(2*_pi)

function gaussian( sigma, x0 )
   return function(x)
	     return _exp((x-x0)^2/(2*sigma*sigma))/(sigma*sqrt2pi)
	  end
end

function poisson(  lambda ) 
   return function(k)
	     return _exp(-lambda) * lambda^k / _factorial(k)
	  end
end
   
function lorentz( gamma, x0 )
   return function(x)
	     return gamma/((x-x0)^2+gamma^2)/_pi
	  end
end

function exponential( lambda )
   return function(x)
	     return lambda*_exp(-lambda*x) 
	  end
end

function binomial( n, p )
   return function(k)
	     return _binomial(n,k) * p^k * (1-p)^(n-k)
	  end
end

function uniform( a, b )
   return function(x)
	     if x>=a and x<=b then
		return 1/(b-a)
	     else
		return 0
	     end
	  end
end

function multinomial( n, ... )
   local p = {...}
   local i = 1
   return function(...)
	     local s = 0
	     local at = {...}
	     for _,x in _ipairs(at) do s = s + x end
	     if s ~= n then 
		return 0 
	     else
		local ret = _factorial(n)
		for i,x in _ipairs(at) do
		   ret = ret * p[i]^x / _factorial(x) 
		end
		return ret
	     end
	  end
end

function dirichlet( n, ... )

   return function(...)
	     
	  end
end



-------------------------------------------------------------------------------
