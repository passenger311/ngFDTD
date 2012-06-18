local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.2",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2",
FILE      = "scape.string.ostream",
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
local _table_concat = table.concat

----------------------------------------------------------------------------
--- <p><b>Prototype:</b> String output stream. </p>
-- Stream that appends to string.
-- </p>
module("scape.string.ostream")
----------------------------------------------------------------------------

this = proto.clone( proto.root, _M )

--- Create table stream.
-- @param str string
-- @return new stream
function new(str)
   if str then
      return proto.clone( this, { buf = { str } } ) 
   else
      return proto.clone( this, { buf = {} } ) 
   end
end

--- Append to stream.
-- @param self stream
-- @param data data
-- @return self
function write(self, data)
   _table_insert(self.buf, data)
   return self
end

--- Flush stream.
-- @param self stream
-- @return self
function flush(self)
   self.buf = { _table_concat(self.buf) }
   return self
end

--- Close stream.
-- @param self stream
-- @return self
function close(self)
   self.buf = nil
   return true
end

--- Convert to string.
-- @param self stream
-- @return self
function __tostring(self)
   return flush(self).buf[1]
end

proto.seal(_M)

----------------------------------------------------------------------------
