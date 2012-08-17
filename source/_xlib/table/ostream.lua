local _H = {
-------------------------------------------------------------------------------
PROJECT   = "xlib",
AUTHOR    = "J Hamm",
VERSION   = "0.2",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2",
FILE      = "xlib.table.ostream",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local proto = L.proto
local utils = L.utils

-------------------------------------------------------------------------------

local _G, _string, _table, _select, _type, _pairs, _ipairs, _assert, _require
   =  _G, string, table, select, type, pairs, ipairs, assert, require
local _table_insert = table.insert

----------------------------------------------------------------------------
--- <p><b>Prototype:</b> Table output stream. </p>
-- Stream that writes to table.
-- </p>
module("xlib.table.ostream")
----------------------------------------------------------------------------

this = proto.clone( proto.root, _M )

--- Create table output stream.
-- @param tab table
-- @return new stream
function new(tab)
   return proto.clone(this, tab or {})
end

--- Append to stream.
-- @param self stream
-- @param data data
-- @return self
function write(self, data)
   _table_insert(self, data)
   return self
end

--- Flush stream (dummy).
-- @param self stream
-- @return self
function flush(self)
   return self
end

--- Close stream (dummy).
-- @param self stream
-- @return self
function close(self)
   return true
end

proto.seal(_M)

----------------------------------------------------------------------------
