local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.math",
VERSION   = "0.1",
DATE      = "18/08/2012 16:09",
COPYRIGHT = "(C) 2012 NEO·LIGHT Project",
-------------------------------------------------------------------------------
}

local _G = _G
local xlib = require( "xlib" )
local module = xlib.module
local proto = xlib.proto

-------------------------------------------------------------------------------
--- <p><b>Module:</b> math utility library. </p>
--
module( _H.FILE )
-------------------------------------------------------------------------------

module.extends("math")

module.imports{ 
   "complex",
   nil
}

--- Truncate number to given precision.
-- @param num number
-- @param prec number of decimal places to truncate to [0]
-- @return truncated number
function trunc(num, prec)
  local e = 10^(prec or 0)
  return floor(num * e) / e
end

--- Round number to given precision.
-- @param num number
-- @param prec number of decimal places to round to [0]
-- @return rounded number
function round(num, prec)
  local e = 10^(prec or 0)
  return floor(num * e + 0.5) / e
end

--- Check whether number is in range.
-- @param num number
-- @param min lower limit
-- @param max upper limit
-- @return number if in range; <tt>nil</tt> otherwise
function inrange(num, min, max)
   if num >= min and num <= max then return num end
   return nil
end

--- Constrain number to limits.
-- @param num number
-- @param min lower limit
-- @param max upper limit
-- @return number in [min,max] interval
function constrain(num, min, max)
   if num < min then 
      return min 
   elseif num > max then
      return max
   else
      return num
   end
end

--- Inverse hyperbolic sine.
-- @param x argument
-- @return result
function asinh(x)
   return log(x+sqrt(x*x+1))
end

--- Inverse hyperbolic cosine.
-- @param x argument
-- @return result
function acosh(x)
   return log(x+sqrt(x*x-1))
end

--- Inverse hyperbolic tangens.
-- @param x argument
-- @return result
function atanh(x)
   return 0.5*log( (1+x)/(1-x) )
end

local factab = {
   [0] = 1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, 39916800,
   479001600, 6227020800, 87178291200, 1307674368000, 20922789888000  
}

--- Factorial function.
-- @param n integer
-- @return factorial <i>n!</i>
function factorial( n )
   local ret = factab[n]
   if ret then return ret end
   local l = #factab
   local ret = factab[l] * factorial2(n, l)
   factab[n] = ret
   return ret
end

function factorial2( n, k )
   local ret = 1
   for i = k+1, n do ret = ret*i end
   return ret
end

--- Binomial coefficient.
-- @param n integer
-- @param k integer
-- @return binomial coefficient, <i>n</i> choose <i>k</i>
function binomial( n, k )
   return factorial2( n, k ) / factorial2( n - k, 1 ) 
end





-------------------------------------------------------------------------------
