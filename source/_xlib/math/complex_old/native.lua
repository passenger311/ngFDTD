-------------------------------------------------------------------------------
-- xlib.math.complex_native
--
-- @copyright $date
-- @author    $author$
-- @release   $release$
-------------------------------------------------------------------------------

-- FIX: complex hyperbolic functions

local proto = require "xlib.proto"
local math = require "xlib.math"

local _print, _dofile = print, dofile
local _pairs, _type, _tostring = pairs, type, tostring
local _sqrt, _log, _log10, _exp = math.sqrt, math.log, math.log10, math.exp
local _cos, _sin, _cosh, _sinh = math.cos, math.sin, math.cosh, math.sinh
local _acos, _atan = math.acos, math.atan
local _atan2, _abs, _pow = math.atan2, math.abs, math.pow
local _round, _trunc = math.round, math.trunc
local _pi_half = math.pi / 2

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> complex number support. </p>
--
module("xlib.math.complex")
-------------------------------------------------------------------------------

this = proto.clone( proto.root, _M )

_M[1] = 0
_M[2] = 0

i = proto.clone(this, { 0 , 1 })

--- Create new complex number.
-- @param re real part
-- @param im imaginary part
-- @return complex number
function new(re, im)
   return proto.clone(this, { re , im or 0 })
end

--- Cast to complex number.
-- @param z real or complex
-- @return complex number
function cast(z)
   if _type(z) == 'number' then
      return new(z)
   end
   return z
end

--- Return real part.
-- @param self complex number
-- @return real part
function re(self)
   return self[1]
end

--- Return imaginary part.
-- @param self complex number
-- @return imaginary part
function im(self)
   return self[2]
end

--- Replace real and imaginary part.
-- @param self complex number
-- @param re real part
-- @param im imaginary part
-- @return complex number
function set(self, re, im)
   self[1] = re
   self[2] = im
   return self
end

--- Return conjugate of complex number.
-- @param self complex number
-- @return conjugate of complex number
function conj(self)
   return this:new{ self[1], -self[2] }
end

--- Return absolute value (radius) of complex number.
-- @param self complex number
-- @return absolute value
function abs(self) 
   local re,im = self[1], self[2]
   return _sqrt(re*re + im*im) 
end

--- Return argument (angle) of complex number.
-- @param self complex number
-- @return argument
function arg(self) 
   return _atan2(self[2],self[1]) 
end

--- Unary minus operator.
-- @param a complex number
-- @return -a
function __unm(a)
   return new( -a[1], -a[2] )
end

--- Addition operator.
-- @param a complex/real number
-- @param b complex/real number
-- @return a+b
function __add(a,b)
   if _type(a) == 'number' then
      return new( a+b[1], b[2] )  
   elseif _type(b) == 'number' then
      return new( a[1]+b, a[2] )
   end
   return new( a[1]+b[1], a[2]+b[2] )
end

--- Substraction operator.
-- @param a complex/real number
-- @param b complex/real number
-- @return a-b
function __sub(a,b) 
   if _type(a) == 'number' then
      return new( a-b[1], -b[2] )  
   elseif _type(b) == 'number' then
      return new( a[1]-b, a[2] )
   end
   return new( a[1]-b[1], a[2]-b[2] )
end

--- Multiplication operator.
-- @param a complex/real number
-- @param b complex/real number
-- @return a*b
function __mul(a,b) 
   if _type(a) == 'number' then
      return new(b[1]*a,b[2]*a)
   elseif _type(b) == 'number' then
      return new(b*a[1],b*a[2])
   end
   local ar, ai, br, bi = a[1],a[2],b[1],b[2]
   return new( ar*br-ai*bi, ar*bi+ai*br )
end

--- Division operator.
-- @param a complex/real number
-- @param b complex/real number
-- @return a/b
function __div(a,b) 
   if _type(a) == 'number' then 
      local br, bi = b[1],b[2]
      local bn = br*br + bi*bi
      return new( a*br/bn, -a*bi/bn ) 
   elseif _type(b) == 'number' then
      return new(a[1]/b,a[2]/b)
   end
   local ar, ai, br, bi = a[1],a[2],b[1],b[2]
   local bn = br*br + bi*bi
   return new( (ar*br+ai*bi)/bn, (-ar*bi+ai*br)/bn )
end

--- Equality operator. 
-- @param a complex number
-- @param b complex number
-- @return a == b
function __eq(a,b)
   return a[1]==b[1] and a[2]==b[2]
end

--- Non-equality operator.
-- @param a complex number
-- @param b comple number
-- @return a ~= b
function __ne(a,b)
   return not a==b
end

--- Cosine of complex number.
-- @param self complex number
-- @return result
function cos(self)
   local re,im = self[1], self[2]
   return new( _cos(re)*_cosh(im), -_sin(re)*_sinh(im) )
end

--- Sine of complex number.
-- @param self complex number
-- @return result
function sin(self)
   local re,im = self[1], self[2]
   return new( _sin(re)*_cosh(im), _cos(re)*_sinh(im) )
end

--- Hyperbolic cosine of complex number.
-- @param self complex number
-- @return result
function cosh(self)
   local re,im = self[1], self[2]
   return new( _cosh(re)*_cos(im), _sinh(re)*_sin(im) )
end

--- Hyperbolic sine of complex number.
-- @param self complex number
-- @return result
function sinh(self)
   local re,im = self[1], self[2]
   return new( _sinh(re)*_cos(im), _cosh(re)*_sin(im) )
end

--- Tangens of complex number.
-- @param self complex number
-- @return result
function tan(self)
   local r
   local c = self:cos()
   local inf = 1/0
   if c[1] == 0 and c[2] == 0 then
      return inf * self:sin()
   elseif self[1] == 0 then
      if self[2] == inf then
	 return new( 0, 1 )
      elseif self[2] == -inf then
	 return new( 0, -1 )
      end
   end
   return self:sin() / c
end

--- Hyperbolic tangens of complex number.
-- @param self complex number
-- @return result
function tanh(self)
   local c = self:cosh()
   local inf = 1/0
   if c[1] == 0 and c[2] == 0 then
      return inf * self:sinh()
   end
   return self:sinh() / c
end

--- Create complex from polar coordinates.
-- @param radius radius
-- @param angle angle
-- @return complex number
function polar(radius,angle)
   return new( radius*_cos(angle), radius*_sin(angle) )
end

--- Natural exponential of complex number.
-- @param self complex number
-- @return result
function exp(self)
   local re,im = self[1], self[2]
   return polar( _exp(re), im )
end

--- Natural logarithm of complex number.
-- @param self complex number
-- @return result
function log(self)
   local re,im = self[1], self[2]
   return new( 0.5*_log(re*re+im*im), self:arg() )
end

--- Base-10 logarithm of complex number.
-- @param self complex number
-- @return result
function log10(self)
  local re,im = self[1], self[2]
  return new( 0.5*_log10(re*re+im*im), self:arg() )
end

--- Square root of complex numer. The branch cut is on the negative axis.
-- @param self complex number
-- @return result
function sqrt(self)
   local re,im = self[1], self[2]
   if re == 0 then
      local t = _sqrt( 0.5 * _abs(im) )
      if im < 0 then
	 return new( t, -t )
      else
	 return new( t, t )
      end
   else
      local t = _sqrt( 2 * ( self:abs() + _abs(re) ) )
      local u = 0.5 * t
      if re > 0 then
	 return new( u, im/t )
      else
	 if im < 0 then
	    return new( _abs(im)/t, - u )
	 else
	    return new( _abs(im)/t,  u )
	 end
      end
   end
end

--- Power function.
-- @param a complex number
-- @param b complex number
-- @return a^b
function pow(a,b)
   if _type(b) == 'number' then
      if ( a[2] == 0 and a[1] > 0 ) then
	 return new(_pow(a[1],b))
      end
      local t = a:log()
      return polar( _exp(b*t[1]), b*t[2] )
   elseif _type(a) == 'number' then
      return ( b * _log(a) ):exp()
   end
   return ( b * a:log() ):exp()
end

--- Power operator.
-- @param a complex number
-- @param b complex number
-- @return a^b
__pow = pow

--- Inverse cosine of complex number.
-- @param self complex number
-- @return result
function acos(self)
   local re, im = self[1], self[2]
   local t = new( 1 - re*re + im*im, - 2*re*im )
   return -i*log( self + i*sqrt(t) )
end

--- Inverse sine of complex number.
-- @param self complex number
-- @return result
function asin(self)
   local re, im = self[1], self[2]
   local t = new( 1 - re*re + im*im, - 2*re*im )
   return -i*log( i*self + sqrt(t) )
end

--- Inverse tangens of complex number.
-- @param self complex number
-- @return result
function atan(self)
   local re, im = self[1], self[2]
   if re == 0 and im*im == 1 then -- poles on imaginary axis
      return new( 0, _abs(im)/im/0 )
   else
      return 0.5*i*( log( 1 - new( -im,re ) ) - log( 1 + new( -im,re ) ) )
   end
end

--- Inverse hyperbolic sine.
-- @param self complex number
-- @return result
function asinh(self)
   return log(self+sqrt(self*self+1))
end

--- Inverse hyperbolic cosine.
-- @param self complex number
-- @return result
function acosh(self)
   return log(self+sqrt(self+1)*sqrt(self-1))
end

--- Inverse hyperbolic tangens.
-- @param self complex number
-- @return result
function atanh(self)   
   return 0.5*(log( (1+self)/(1-self) ) )
end


--- Round complex number to given precision.
-- @param self complex number
-- @param prec precision
-- @return result
function round(self, prec)
   return new( _round(self[1],prec), _round(self[2],prec) )
end

--- Truncate complex number to given precision.
-- @param self complex number
-- @param prec precision
-- @return result
function trunc(self, prec)
   return new( _trunc(self[1],prec), _trunc(self[2],prec) )
end

--- <i>tostring()</i> operator.
-- @param self complex number
-- @return string which represents complex number
function __tostring(self)
   return "(".._tostring(self[1])..",".._tostring(self[2])..")"
end

proto.seal(this)

-------------------------------------------------------------------------------

