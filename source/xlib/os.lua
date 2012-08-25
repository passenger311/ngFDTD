local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.os",
VERSION   = "0.1",
DATE      = "18/08/2012 16:09",
COPYRIGHT = "(C) 2012 NEO·LIGHT Project",
-------------------------------------------------------------------------------
}


local ffi = require( "ffi" )
local xlib = require( "xlib" )
local module = xlib.module


-------------------------------------------------------------------------------

local G = _G
local _pairs = pairs

-------------------------------------------------------------------------------
--- <p><b>Module:</b> OS information. 
-- </p>
--
module( _H.FILE )
------------------------------------------------------------------------------

module.imports{ 
}

------------------------------------------------------------------------------

type = ffi.os
arch = ffi.arch

info = { 
   le = ffi.abi("le"),
   be = ffi.abi("be"),
   fpu = ffi.abi("fpu"),
   hardfp = ffi.abi("hardfp"),
   softfp = ffi.abi("softfp"),
   win = ffi.abi("win"),
   eabi = ffi.abi("eabi")
}

infostring = type.." "..arch.." ["

for k,v in _pairs(info) do
   if v then
      infostring = infostring..k.." "
   end
end

infostring = infostring:gsub("%s$","]")

------------------------------------------------------------------------------
