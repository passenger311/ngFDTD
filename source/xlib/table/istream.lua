local _H = {
-------------------------------------------------------------------------------
PROJECT   = "neolib",
AUTHOR    = "J Hamm",
VERSION   = "0.2",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2",
FILE      = "neolib.table.istream",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local proto = L.proto
local utils = L.utils

-------------------------------------------------------------------------------


----------------------------------------------------------------------------
--- <p><b>Prototype:</b> Table input stream. </p>
-- Stream that reads from table.
-- </p>
module("neolib.table.istream")
----------------------------------------------------------------------------

this = proto.clone( proto.root, _M )

--- Create table input stream.
-- @param tab table
-- @return new stream
function new(tab)
   return proto.clone(this, tab or {})
end

--- Return stream lines iterator.
-- @param self stream
-- @return data
function lines(self)
   local idx = 0
   return function()
	     idx = idx + 1
	     return self[idx]
	  end
end

--- Return stream bytes iterator.
-- @param self stream
-- @return data
function bytes(self)
   local idx = 0
   return function()
	     idx = idx + 1
	     return self[idx]
	  end
end



--- Close stream (dummy).
-- @param self stream
-- @return self
function close(self)
   return true
end

proto.seal(_M)

----------------------------------------------------------------------------
