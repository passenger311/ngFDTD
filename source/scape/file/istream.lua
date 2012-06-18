local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.3",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2",
FILE      = "scape.file.istream",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local proto = L.proto

-------------------------------------------------------------------------------

local _open = io.open

----------------------------------------------------------------------------
--- <p><b>Prototype:</b> File input stream. </p>
-- Stream that reads from file.
-- </p>
module("scape.file.istream")
----------------------------------------------------------------------------

this = proto.clone( proto.root, _M )

--- Create file input stream.
-- @param fn filename
-- @param rmode read mode
-- @return new stream
function new(fn, rmode)
   local fh = _open(fn, "r")
   if fh then
      return proto.clone(this, { fh, rmode })
   end
end

--- Return stream line iterator.
-- @param self stream
-- @return data
function lines(self)
   return function()
	     return self[0]:read(self[1],"*l")
	  end
end

--- Close stream.
-- @param self stream
-- @return self
function close(self)
   return self[0]:close()
end

proto.seal(_M)

----------------------------------------------------------------------------
