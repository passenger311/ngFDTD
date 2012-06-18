local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2",
FILE      = "fun",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local config = L.config
local module = L.module
local utils = L.utils

-------------------------------------------------------------------------------

local _select, _pairs, _ipairs, _unpack, _assert, _loadstring, _setfenv = 
   select, pairs, ipairs, unpack, assert, loadstring, setfenv
local _getfenv = getfenv
local _random = math.random
local _insert = table.insert

-------------------------------------------------------------------------------
--- <p><b>Module:</b> Functional extensions. </p>
--
module( "scape.fun" )
------------------------------------------------------------------------------

module.imports{ 
   "op"
}

------------------------------------------------------------------------------

local rres = config.RANDOM_RESOLUTION

--- Flip a coin with bias. The bias corresponds to the probability of
-- a positive result (<tt>true</tt).
-- @param bias bias value [0.5]
-- @return <tt>true</tt> if random number [0..1] is smaller than bias; 
-- <tt>false</tt> otherwise 
function flip( bias )
   bias = bias or 0.5
   local r = _random(0,rres)/rres
   return r < bias 
end

--- If-else.
-- @param cond condition
-- @param val1 value 1 
-- @param val2 value 2
-- @return val1 if cond is not <tt>nil</tt> or <tt>false</tt>, val2 otherwise
ifelse = utils.select

--- Memoize function result to create persistence results in sucessive calls.
-- @param f function whose result to memoize
-- @return memoized function 
function mem(f)
   local res = nil
   return function(...)
	     if not res then res = {f(...)} end
	     return _unpack(res)
	  end
end

--- Flip a coin with bias. The bias corresponds to the probability of
-- a positive result (<tt>true</tt).
-- @param bias bias value [0.5]
-- @return <tt>true</tt> if random number [0..1] is smaller than bias; 
-- <tt>false</tt> otherwise 
function memflip(bias)
   return mem(flip)(bias)
end

--- Chain two single argument functions
-- @param f function f(x)
-- @param g function g(x)
-- @return composition (f*g) = f(g(x))
function chain1(f,g)
   return function(x)
	     return f(g(x))
	  end
end

--- Partially apply function to first arguments. 
-- @param f function
-- @param v first argument
-- @return function f(v,...)
function bind1 (f,v)
   return function(...) return f(v,...) end
end

--- Partially apply function on first n arguments. 
-- @param f function
-- @param ... argument list with values to insert
-- @return function
function bindn (f,v,...)
   if v == nil then return f end
   return bindn( bind1(f,v), ... )
end

--- Partially apply function with arbitrary arguments. 
-- @param f function
-- @param ... argument list of values to insert; <tt>nil</tt> marks open slots
-- @return function
function bind(f, ...)
   local ct, ot = {...}, {}
   for i=1,_select('#',...) do
      if _select(i,...) then _insert(ot,i) end
   end
   return function(...)
	     local at = {...}
	     for _,idx in _ipairs(ot) do _insert(at,idx,ct[idx]) end
	     return f(_unpack(at))
	  end
end

--- Curry 2 argument function
-- @param f function f(x,y)
-- @return curried function
function  curry2(f)
   return function(x)
	     return function(y)
		       return f(x,y)
		    end
	  end
end

--- Curry 3 argument function
-- @param f function f(x,y,z)
-- @return curried function
function  curry3(f)
   return function(x)
	     return function(y)
		       return function(z)
				 return f(x,y,z)
			      end
		    end
	  end
end


--- Fail.
function fail()
   _assert(false, "fail")
end

--- Anonymous function of x
-- @param str x-dependend rvalue expression
-- @return function
function fx(str)
   local chk = _loadstring("return function(x) ".."return "..str.." end")
--   _setfenv(chk,_getfenv(2))
   return chk()
end

--- Anonymous function of x and y
-- @param str x/y-dependend rvalue expression
-- @return function
function fxy(str)
   local chk = _loadstring("return function(x,y) ".."return "..str.." end")
   return chk()
end

--- Anonymous function of x and y and z
-- @param str x/y/z-dependend rvalue expression
-- @return function
function fxyz(str)
   local chk = _loadstring("return function(x,y,z) ".."return "..str.." end")
   return chk()
end


--function test_model()
--   local cloudy = flip(0.5)
--   local rain = flip(ifelse(cloudy, 0.8, 0.2))
--   local sprinkler = flip(ifelse(cloudy, 0.1, 0.5))
--   local wet_roof = flip(0.7) and rain
--   local wet_grass = flip(0.9) and rain or flip(0.9) and sprinkler
--   if wet_grass then return rain else fail() end
--end

------------------------------------------------------------------------------
