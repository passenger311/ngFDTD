local _H = {
-------------------------------------------------------------------------------
FILE      = "fdtd.shapes.basetype",
VERSION   = "0.1",
DATE      = "14/08/2012 16:01",
COPYRIGHT = "GPL V2",
-------------------------------------------------------------------------------
}

local xlib = require( "xlib" )
local module = xlib.module
local proto = xlib.proto

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> Shape base type.
-- </p>
module( _H.FILE )
-------------------------------------------------------------------------------

local this = proto.clone( _M, proto.root )

contains = proto.virtfun()

proto.seal(this)

-------------------------------------------------------------------------------
