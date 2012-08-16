local _H = {
-------------------------------------------------------------------------------
PROJECT   = "neolib",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "14/08/2012 16:01",
COPYRIGHT = "GPL V2",
FILE      = "neolib.math.consts",
-------------------------------------------------------------------------------
}


local L = require( _H.PROJECT )
local module = L.module

-------------------------------------------------------------------------------

local _math = math

-------------------------------------------------------------------------------
--- <p><b>Module:</b> mathematical and scientific constants. </p>
--
module("neolib.math.consts")
-------------------------------------------------------------------------------

--- Table of mathematical constants.
-- @class table
-- @name math
-- @field infty Infinity
-- @field pi Pi
-- @field e Euler's number
-- @field catalan Catalan's constant
-- @field euler Euler-Mascheroni constant
-- @field phi Golden number
-- @field omega Omega constant
-- @field sqrt2 Square root of 2
-- @field feigenbaum Feigenbaum constant
math = {}

math.infty = 1/0
math.pi = _math.pi
math.twopi = 2 * _math.pi 
math.e = _math.exp(1)
math.catalan = 0.9159655941772
math.euler = 0.5772156649015
math.phi = ( 1 + _math.sqrt(5) ) / 2
math.omega = 0.5671432904098
math.sqrt2 = _math.sqrt(2)
math.feigenbaum = 4.669201609103

--- Table of physical constants.
-- @class table
-- @name phys
phys = {}

-- @field speed of light
phys.c = 2.99792458e8   -- m/s

-- @field elementary charge
phys.e = 1.60217653e-19 -- A s

-- @field magnetic constant
phys.mu0 = 4*math.pi*1e-7 -- N A^(-2)

-- @field electric constant
phys.eps0 = 1/(phys.mu0 * phys.c^2 )  -- A^2 s^4 / ( kg m^3 )

-- @field Avogadro's constant
phys.L = 6.0221417930e23 -- 1/mol
phys.NA = phys.L -- 1/mol

-- Planck's constant 
phys.h = 6.6260689633e-34 -- J s

-- reduced Planck's constant 
phys.hbar = phys.h / math.twopi  -- J s

-- Newtonian constant of gravitation
phys.G = 6.6742867e-11 -- m^3 kg^(-1) s^(-2)

-- vacuum impedance
phys.Z0 = phys.mu0*phys.c -- Ohm

-- coulomb's constant
phys.ke = 1/(4*math.pi*phys.eps0) -- N m^2 C^(-2) 

-- electron mass
phys.me = 9.1093821545e-31 -- kg

-- Bohr's magneton
phys.muB = phys.e * phys.hbar / ( 2 * phys.me ) -- J T^(-1)

-- fine structure constant 
phys.alpha = 7.297352537650e-3 --

-- Rydberg constant
phys.R = 10973731.56852573 -- 1/m

-- Boltzmann constant
phys.kB = 1.380650424e-23 -- J/K
phys.k = phys.kB

-- atomic mass unit
phys.mu = 1.6605388628e-27 -- kg

-- proton mass
phys.mp = 1.67262163783e-27 -- kg


-------------------------------------------------------------------------------
