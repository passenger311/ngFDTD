local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "31/08/2011 12:21",
COPYRIGHT = "GPL V2",
FILE      = "scape.file.ostream",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local proto = L.proto
local utils = L.utils

-------------------------------------------------------------------------------

local _G, _string, _table, _select, _type, _pairs, _ipairs, _assert, _require
   =  _G, string, table, select, type, pairs, ipairs, assert, require
local _open = io.open

----------------------------------------------------------------------------
--- <p><b>Prototype:</b> File output stream. </p>
-- Stream that appends to file.
-- </p>
module("scape.file.ostream")
----------------------------------------------------------------------------

this = proto:_adopt( _M )

--- Create file stream.
-- @param fn filename
-- @return new stream
function new(fn)
   fh = _assert(_open(fn,"w+"))
   return this:_adopt{ fh = fh }
end

--- Append to stream.
-- @param self stream
-- @param data data
-- @return self
function write(self, data)
   self.fh:write(data)
   return self
end

--- Flush stream.
-- @param self stream
-- @return self
function flush(self)
   self.fh:flush()
   return self
end

--- Close stream.
-- @param self stream
-- @return self
function close(self)
   return self.fh:close()
end

this:_seal()

----------------------------------------------------------------------------
