local _H = {
-------------------------------------------------------------------------------
FILE      = "fdtd.models.response.basetype",
VERSION   = "0.1",
DATE      = "14/08/2012 16:01",
COPYRIGHT = "GPL V2",
-------------------------------------------------------------------------------
}

local xlib = require( "xlib" )
local fdtd = require( "fdtd" )
local module = xlib.module
local proto = xlib.proto

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> Response model base type.
-- </p>
module( _H.FILE )
-------------------------------------------------------------------------------

local parent = fdtd.models.basetype
local this = proto.clone( _M, parent )


proto.seal(this)

-------------------------------------------------------------------------------
