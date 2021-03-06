local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.math.complex",
VERSION   = "0.1",
DATE      = "18/08/2012 16:09",
COPYRIGHT = "(C) 2012 NEO·LIGHT Project",
-------------------------------------------------------------------------------
}

local xlib = require( "xlib" )
local proto = xlib.proto
local module = xlib.module
local math = xlib.math
local ffi = require( "ffi" )

-------------------------------------------------------------------------------

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
module( _H.FILE )
-------------------------------------------------------------------------------

--- from complex.h
ffi.cdef([[
complex double csin(complex double arg);
complex double ccos(complex double arg);
double cimag(complex double arg);
double creal(complex double arg);
double cabs(complex double arg);
double carg(complex double arg);
complex double csqrt(complex double arg);
complex double conj(complex double arg);
complex double csin(complex double arg);
complex double ccos(complex double arg);
complex double ctan(complex double arg);
complex double csinh(complex double arg);
complex double ccosh(complex double arg);
complex double ctanh(complex double arg);
complex double clog(complex double arg);
complex double cexp(complex double arg);
complex double cpow(complex double arg1, complex double arg2);
complex double casin(complex double arg);
complex double cacos(complex double arg);
complex double catan(complex double arg);
complex double casinh(complex double arg);
complex double cacosh(complex double arg);
complex double catanh(complex double arg);
]])

-- complex arithmetic is currently not supported for luaJIT complex types.
-- this workaround call's some c99 subroutines to do the operations 

local this = proto.clone( _M, proto.root )

_M[1] = ffi.new("complex double")

--- Create new complex number.
-- @param re real part
-- @param im imaginary part
-- @return complex number
function new(re, im)
   return this:adopt{ ffi.new("complex double", {re, im or 0}) }
end

i = new( 0 , 1 )

--- Cast to complex number.
-- @param z real or complex
-- @return complex number
function cast(z)
   if _type(z) == 'number' then
      return new(z)
   end
   return z
end

--- Box complex number.
-- @param z comlex userdata
-- @return complex number
function box(z)
   return this:adopt{ z }
end

--- Return real part.
-- @param self complex number
-- @return real part
function re(self)
   return self[1].re
end

--- Return imaginary part.
-- @param self complex number
-- @return imaginary part
function im(self)
   return self[1].im
end

--- Replace real and imaginary part.
-- @param self complex number
-- @param re real part
-- @param im imaginary part
-- @return complex number
function set(self, re, im)
   self[1] = ffi.new("complex double", {re,im or 0} )
   return self
end

--- Return conjugate of complex number.
-- @param self complex number
-- @return conjugate of complex number
function conj(self)
   return this:new{ self[1].re, -self[1].im }
end

--- Return absolute value (radius) of complex number.
-- @param self complex number
-- @return absolute value
function abs(self) 
   return ffi.C.cabs(self[1]) 
end

--- Return argument (angle) of complex number.
-- @param self complex number
-- @return argument
function arg(self) 
   return ffi.C.carg(self[1]) 
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
      return new( a+b[1].re, b[1].im )  
   elseif _type(b) == 'number' then
      return new( a[1].re+b, a[1].im )
   end
   return new( a[1].re+b[1].re, a[1].im+b[1].im )
end

--- Substraction operator.
-- @param a complex/real number
-- @param b complex/real number
-- @return a-b
function __sub(a,b) 
   if _type(a) == 'number' then
      return new( a-b[1].re, -b[1].im )  
   elseif _type(b) == 'number' then
      return new( a[1].re-b, a[1].im )
   end
   return new( a[1].re-b[1].re, a[1].im-b[1].im )
end

--- Multiplication operator.
-- @param a complex/real number
-- @param b complex/real number
-- @return a*b
function __mul(a,b) 
   if _type(a) == 'number' then
      return new(b[1].re*a,b[1].im*a)
   elseif _type(b) == 'number' then
      return new(b*a[1].re,b*a[1].im)
   end
   local ar, ai, br, bi = a[1].re,a[1].im,b[1].re,b[1].im
   return new( ar*br-ai*bi, ar*bi+ai*br )
end

--- Division operator.
-- @param a complex/real number
-- @param b complex/real number
-- @return a/b
function __div(a,b) 
   if _type(a) == 'number' then 
      local br, bi = b[1].re,b[1].im
      local bn = br*br + bi*bi
      return new( a*br/bn, -a*bi/bn ) 
   elseif _type(b) == 'number' then
      return new(a[1].re/b,a[1].im/b)
   end
   local ar, ai, br, bi = a[1].re,a[1].im,b[1].re,b[1].im
   local bn = br*br + bi*bi
   return new( (ar*br+ai*bi)/bn, (-ar*bi+ai*br)/bn )
end

--- Equality operator.
-- @param a complex number
-- @param b complex number
-- @return a == b
function __eq(a,b)
   return a[1].re==b[1].re and a[1].im==b[1].im
end

--- Non-equality operator.
-- @param a complex number
-- @param b complex number
-- @return a ~= b
function __ne(a,b)
   return not a==b
end

--- Cosine of complex number.
-- @param self complex number
-- @return result
function cos(self)
   return box( ffi.C.ccos(self[1]) )
end

--- Sine of complex number.
-- @param self complex number
-- @return result
function sin(self)
   return box( ffi.C.csin(self[1]) )
end

--- Hyperbolic cosine of complex number.
-- @param self complex number
-- @return result
function cosh(self)
   return box( ffi.C.ccosh(self[1]) )
end

--- Hyperbolic sine of complex number.
-- @param self complex number
-- @return result
function sinh(self)
   return box( ffi.C.csinh(self[1]) )
end

--- Tangens of complex number.
-- @param self complex number
-- @return result
function tan(self)
   return box( ffi.C.ctan(self[1]) )
end

--- Hyperbolic tangens of complex number.
-- @param self complex number
-- @return result
function tanh(self)
   return box( ffi.C.ctanh(self[1]) )
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
   return box( ffi.C.cexp(self[1]) )
end

--- Natural logarithm of complex number.
-- @param self complex number
-- @return result
function log(self)
   return box( ffi.C.clog(self[1]) )
end

--- Square root of complex numer. The branch cut is on the negative axis.
-- @param self complex number
-- @return result
function sqrt(self)
   return box( ffi.C.csqrt(self[1]) )
end

--- Power function.
-- @param a complex number
-- @param b complex number
-- @return a^b
function pow(a,b)
   return box( ffi.C.cpow(cast(a)[1],cast(b)[1]) )
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
   return box( ffi.C.cacos(self[1]) )
end

--- Inverse sine of complex number.
-- @param self complex number
-- @return result
function asin(self)
   return box( ffi.C.casin(self[1]) )
end

--- Inverse tangens of complex number.
-- @param self complex number
-- @return result
function atan(self)
   return box( ffi.C.catan(self[1]) )
end

--- Inverse hyperbolic sine.
-- @param self complex number
-- @return result
function asinh(self)
   return box( ffi.C.casinh(self[1]) )
end

--- Inverse hyperbolic cosine.
-- @param self complex number
-- @return result
function acosh(self)
   return box( ffi.C.cacosh(self[1]) )
end

--- Inverse hyperbolic tangens.
-- @param self complex number
-- @return result
function atanh(self)   
   return box( ffi.C.catanh(self[1]) )
end


--- Round complex number to given precision.
-- @param self complex number
-- @param prec precision
-- @return result
function round(self, prec)
   return new( _round(self[1].re,prec), _round(self[1].im,prec) )
end

--- Truncate complex number to given precision.
-- @param self complex number
-- @param prec precision
-- @return result
function trunc(self, prec)
   return new( _trunc(self[1].re,prec), _trunc(self[1].im,prec) )
end

--- <i>tostring()</i> operator.
-- @param self complex number
-- @return string which represents complex number
function __tostring(self)
   return "(".._tostring(self[1].re)..",".._tostring(self[1].im)..")"
end

proto.seal(this)

-------------------------------------------------------------------------------

