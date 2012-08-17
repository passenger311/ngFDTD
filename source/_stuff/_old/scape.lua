local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "31/08/2011 12:21",
COPYRIGHT = "GPL V2",
FILE      = "scape",
-------------------------------------------------------------------------------
}

local module = require( _H.PROJECT..".module" )

-------------------------------------------------------------------------------
---<p><b>Module</b>: Main module. </p>
-- </p>
-- @class module
-- @name scape
module( "scape" )
-------------------------------------------------------------------------------

module.imports{
   "config",
   "utils",
   "module",
   "object",
   "proto",
   "class",
   "math",
   "file",
   "io",
   "string",
   "table",
   "struct",
   "os",
   "table",
   "string",
   "debug",
   "coroutine",
   "unit"
}

-------------------------------------------------------------------------------

--- Project signature.
signature = _H

-------------------------------------------------------------------------------
