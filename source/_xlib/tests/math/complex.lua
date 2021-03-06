local _H = {
-------------------------------------------------------------------------------
PROJECT   = "xlib",
FILE      = "tests.math.complex",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2"
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local lib = L.lib
local unit = L.unit
local class = L.class
local math = L.math
local complex = math.complex

-------------------------------------------------------------------------------

local _pcall, _print, _table, _ipairs = pcall, print, table, ipairs

-------------------------------------------------------------------------------
module( "xlib.tests.math.complex" )
-------------------------------------------------------------------------------

this = unit.new(_M, { name = _H.FILE, repetition=100 } )

function setup(self)
   self.c = {}
   for i=-5,5 do
      for j=-5,5 do
	 _table.insert(self.c, complex.new(i*0.5,j*0.5))
      end
   end
end

function addsub1(self)
   local b = complex.new( 2, 4 )
   for _,a in _ipairs(self.c) do
      unit.assert( ( a - b ) + ( a + b ) == complex.new(2)*a )
   end
end

function addsub2(self)
   local b = complex.new( 2, 4 )
   for _,a in _ipairs(self.c) do
      unit.assert(  ( a - b ) * ( a + b ) == a*a - b*b )
   end
end

function muldiv1(self)
   local b = complex.new( 2, 4 )
   for _,a in _ipairs(self.c) do
      if a ~= complex.new(0,0) then
	 unit.assert(  ( a / b * b / a ):round(13) == complex.new(1) )
      end
   end
end

function muldiv2(self)
   local b = complex.new(3)
   for _,a in _ipairs(self.c) do
      if a ~= complex.new(0,0) then
	 unit.assert(  ( a / b * b / a ):round(13) == complex.new(1) )
      end
   end
end

function sin(self)
   for _,a in _ipairs(self.c) do
      unit.assert( a:asin():sin():round(13) == a )
   end
end

function cos(self)
   for _,a in _ipairs(self.c) do
      unit.assert( a:acos():cos():round(13) == a )
   end
end

function tan(self)
   for _,a in _ipairs(self.c) do
      unit.assert( a:atan():tan():round(13) == a )
   end
end

function sinh(self)
   for _,a in _ipairs(self.c) do
      unit.assert( a:asinh():sinh():round(13) == a )
   end
end

function cosh(self)
   for _,a in _ipairs(self.c) do
      unit.assert( a:acosh():cosh():round(13) == a )
   end
end

function tanh(self)
   for _,a in _ipairs(self.c) do
      if math.abs(a:re()) <= 1 and math.abs(a:im()) <= 1 then
	 unit.assert( a:tanh():atanh():round(13) == a )
      end
   end
end


function log(self)
   for _,a in _ipairs(self.c) do
      unit.assert(  a:exp():log():round(13) == a )
   end
end

function sqrt(self)
   for _,a in _ipairs(self.c) do
      local b = a:sqrt()
      unit.assert(  (b*b):round(13) == a )
   end
end

function polar(self)
   for _,a in _ipairs(self.c) do
      unit.assert(  complex.polar(a:abs(),a:arg()):round(13) == a )
   end
end

function pow3(self)
   for _,a in _ipairs(self.c) do
      unit.assert(  a:pow(1/3):pow(3):round(13) == a )
   end
end

function pow3i(self)
   for _,a in _ipairs(self.c) do
      if ( a ~= complex.new() ) then
	 unit.assert(a:pow(complex.new(0,1/3)):pow(complex.new(0,3)):round(13) == (1/a):round(13) )
      end
   end
end




------------------------------------------------------------------------------
