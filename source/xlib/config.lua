local _H = {
-------------------------------------------------------------------------------
PROJECT   = "neolib",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "14/08/2012 16:01",
COPYRIGHT = "GPL V2",
FILE      = "neolib.config",
-------------------------------------------------------------------------------
}

local module = require( _H.PROJECT..".module" )

-------------------------------------------------------------------------------

local _G = _G

-------------------------------------------------------------------------------
module( "neolib.config" )
-------------------------------------------------------------------------------

LIB_EXTEND = true
WARN_COLLISIONS = true
SAFE_DIRSEP = "\254"
RANDOM_RESOLUTION = 1e7
MATH_COMPLEX_FFI = false

-- Inherited

NAME = module.NAME
IS_JIT = module.IS_JIT
DIRSEP = module.DIRSEP
PATH_MARK = module.PATH_MARK

-- Global

_G.package.path = "./?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/usr/local/lib/lua/5.1/?.lua;/usr/local/lib/lua/5.1/?/init.lua;/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua"
_G.package.cpath = "./?.so;/usr/local/lib/lua/5.1/?.so;/usr/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so"


-------------------------------------------------------------------------------
