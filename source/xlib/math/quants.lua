local _H = {
-------------------------------------------------------------------------------
PROJECT   = "neolib",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "14/08/2012 16:01",
COPYRIGHT = "GPL V2",
FILE      = "neolib.math.quants",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local proto = L.proto
local units = L.math.units
local consts = L.math.consts

-------------------------------------------------------------------------------

local _pairs, _type, _tostring, _loadstring, _getfenv, _setfenv 
   = pairs, type, tostring, loadstring, getfenv, setfenv
local _sqrt = math.sqrt

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> A quantity is a value (magnitude) with units. </p>
--
module("neolib.math.quants")
-------------------------------------------------------------------------------

this = proto:_adopt( _M )

-- SI unit system

_M[1] = 0 -- magnitude
_M[2] = units.new{ 0,0,0,0,0,0,0 } -- unit

--- Create new quantity.
-- @param quantity
-- @return new vector 
function new(unit)
   if _type(unit) == 'string' then
      chk = _loadstring("return "..unit)
      _setfenv(chk, _getfenv(1))
      return chk()
   elseif _type(unit) == 'number' then
      return this:_adopt{ unit, unit.new{ 0,0,0,0,0,0,0 } }
   else
      return this:_adopt( unit )
   end
end

function __eq(a,b)
   return a[1] == b[1] and a[2] == b[2]
end

function __ne(a,b)
   return not a == b
end

function __gt(a,b)
   if a[2] == b[2] then
      return a[1] > b[1]
   end
end

function __lt(a,b)
   if a[2] == b[2] then
      return a[1] < b[1]
   end
end

function __ge(a,b)
   if a[2] == b[2] then
      return a[1] >= b[1]
   end
end

function __le(a,b)
   if a[2] == b[2] then
      return a[1] <= b[1]
   end
end

function __unm(a)
   return new{ - a[1], a[2] }
end

function __add(a,b)
   if a[2] == b[2] then 
      return new{ a[1]+b[1], a[2]-b[2] }
   end
end

function __sub(a,b)
   if a[2] == b[2] then 
      return new{ a[1]-b[1], a[2]-b[2] }
   end
end

function __mul(a,b)
   if _type(a) == 'number' then
      return new{ a*b[1], b[2] }
   elseif _type(b) == 'number' then
      return new{ a[1]*b, a[2] }
   else
      return new{ a[1]*b[1], a[2]*b[2] }
   end
end

function __div(a,b)
   if _type(a) == 'number' then
      return new{ a/b[1], -b[2] }
   elseif _type(b) == 'number' then
      return new{ a[1]/b, a[2] }
   else
      return new{ a[1]/b[1], a[2]/b[2] }
   end
end

function __pow(a,b)
   if _type(b) == 'number' then
      return new{ a[1]^b, a[2]^b }
   end
end

function sqrt(a)
   return new{ _sqrt(a[1]), a[2]:sqrt() }   
end

function __tostring(a)
   return _tostring(a[1]).." ".._tostring(a[2])
end

-- power prefixes

pfix = { y = 1e-24, z = 1e-21, a = 1e-18, f = 1e-15, p = 1e-12, n = 1e-9, 
	 u = 1e-6, m = 1e-3, c = 1e-2, d = 1e-1, da = 1e1, h = 1e2, k = 1e3, 
	 M = 1e6, G = 1e9, T = 1e12, P = 1e15, E = 1e18, Z = 1e21, Y = 1e24 }


-- create symbols for base units

scalar = new{ 1, units.new{ 0,0,0,0,0,0,0 } }

m = new{ 1, units.new{ 1,0,0,0,0,0,0 } }
kg = new{ 1, units.new{ 0,1,0,0,0,0,0 } }
s = new{ 1, units.new{ 0,0,1,0,0,0,0 } }
A = new{ 1, units.new{ 0,0,0,1,0,0,0 } }
K = new{ 1, units.new{ 0,0,0,0,1,0,0 } }
cd = new{ 1, units.new{ 0,0,0,0,0,1,0 } }
mol = new{ 1, units.new{ 0,0,0,0,0,0,1 } }

-- m

am = m*(pfix.a)
fm = m*(pfix.f)
nm = m*(pfix.n)
um = m*(pfix.u)
mm = m*(pfix.m)
cm = m*(pfix.c)
km = m*(pfix.k)

-- kg

g = kg*(pfix.m)
mg = g*(pfix.m)
ug = g*(pfix.u)

-- s

as = s*(pfix.a)
fs = s*(pfix.f)
ns = s*(pfix.n)
us = s*(pfix.u)
ms = s*(pfix.m)

-- A

fA = A*(pfix.f)
pA = A*(pfix.p)
nA = A*(pfix.n)
uA = A*(pfix.u)
mA = A*(pfix.m)
kA = A*(pfix.k)
MA = A*(pfix.M)
GA = A*(pfix.G)
TA = A*(pfix.T)

-- K

fK = K*(pfix.f)
pK = K*(pfix.p)
nK = K*(pfix.n)
uK = K*(pfix.u)
mK = K*(pfix.m)
kK = K*(pfix.k)
MK = K*(pfix.M)
GK = K*(pfix.G)
TK = K*(pfix.T)

-- cd

fcd = cd*(pfix.f)
pcd = cd*(pfix.p)
ncd = cd*(pfix.n)
ucd = cd*(pfix.u)
mcd = cd*(pfix.m)
kcd = cd*(pfix.k)
Mcd = cd*(pfix.M)
Gcd = cd*(pfix.G)
Tcd = cd*(pfix.T)

-- mol

fmol = mol*(pfix.f)
pmol = mol*(pfix.p)
nmol = mol*(pfix.n)
umol = mol*(pfix.u)
mmol = mol*(pfix.m)
kmol = mol*(pfix.k)
Mmol = mol*(pfix.M)
Gmol = mol*(pfix.G)
Tmol = mol*(pfix.T)

-- Ohm

Ohm = m^2*kg*s^(-3)*A^(-2)
nOhm = Ohm*(pfix.n)
uOhm = Ohm*(pfix.u)
mOhm = Ohm*(pfix.m)
kOhm = Ohm*(pfix.k)

-- Joule

J = kg*m^2/s^2
aJ = J*(pfix.a)
fJ = J*(pfix.f)
pJ = J*(pfix.p)
nJ = J*(pfix.n)
uJ = J*(pfix.u)
mJ = J*(pfix.m)
kJ = J*(pfix.k)
MJ = J*(pfix.M)
GJ = J*(pfix.G)
TJ = J*(pfix.T)

-- Watt

W = J/s
aW = W*(pfix.a)
fW = W*(pfix.f)
pW = W*(pfix.p)
nW = W*(pfix.n)
uW = W*(pfix.u)
mW = W*(pfix.m)
kW = W*(pfix.k)
MW = W*(pfix.M)
GW = W*(pfix.G)
TW = W*(pfix.T)

-- Volt

V = W/A
aV = V*(pfix.a)
fV = V*(pfix.f)
pV = V*(pfix.p)
nV = V*(pfix.n)
uV = V*(pfix.u)
mV = V*(pfix.m)
kV = V*(pfix.k)
MV = V*(pfix.M)
GV = V*(pfix.G)
TV = V*(pfix.T)

-- Coulomb

C = A*s
aC = C*(pfix.a)
fC = C*(pfix.f)
pC = C*(pfix.p)
nC = C*(pfix.n)
uC = C*(pfix.u)
mC = C*(pfix.m)
kC = C*(pfix.k)
MC = C*(pfix.M)
GC = C*(pfix.G)
TC = C*(pfix.T)

-- Hertz

Hz = 1/s
uHz = Hz*(pfix.u)
mHz = Hz*(pfix.m)
kHz = Hz*(pfix.k)
MHz = Hz*(pfix.M)
GHz = Hz*(pfix.G)
THz = Hz*(pfix.T)

-- Tesla

T = V*s/m^2
aT = T*(pfix.a)
fT = T*(pfix.f)
pT = T*(pfix.p)
nT = T*(pfix.n)
uT = T*(pfix.u)
mT = T*(pfix.m)
kT = T*(pfix.k)
MT = T*(pfix.M)
GT = T*(pfix.G)
TT = T*(pfix.T)

-- Weber

Wb = V*s
aWb = Wb*(pfix.a)
fWb = Wb*(pfix.f)
pWb = Wb*(pfix.p)
nWb = Wb*(pfix.n)
uWb = Wb*(pfix.u)
mWb = Wb*(pfix.m)
kWb = Wb*(pfix.k)
MWb = Wb*(pfix.M)
GWb = Wb*(pfix.G)
TWb = Wb*(pfix.T)

-- Newton

N = kg*m/s^2
aN = N*(pfix.a)
fN = N*(pfix.f)
pN = N*(pfix.p)
nN = N*(pfix.n)
uN = N*(pfix.u)
mN = N*(pfix.m)
kN = N*(pfix.k)
MN = N*(pfix.M)
GN = N*(pfix.G)
TN = N*(pfix.T)

-- Pascal

Pa = N/m^2
aPa = Pa*(pfix.a)
fPa = Pa*(pfix.f)
pPa = Pa*(pfix.p)
nPa = Pa*(pfix.n)
uPa = Pa*(pfix.u)
mPa = Pa*(pfix.m)
kPa = Pa*(pfix.k)
MPa = Pa*(pfix.M)
GPa = Pa*(pfix.G)
TPa = Pa*(pfix.T)

-- erg (non-SI)

erg = 100 * nJ


-- Physical units

e = consts.phys.e * C
eV = consts.phys.e * J
c = consts.phys.c * m/s
L = consts.phys.L / mol
mu0 = consts.phys.mu0 * N * A^(-2)
eps0 = consts.phys.eps0 * A^2*s^4/(kg*m^3)
h = consts.phys.h * J*s
hbar = consts.phys.hbar * J*s

-- Electron volt

keV = pfix.k * eV
MeV = pfix.M * eV
GeV = pfix.G * eV


-------------------------------------------------------------------------------
