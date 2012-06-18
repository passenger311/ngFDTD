local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "31/08/2011 12:21",
COPYRIGHT = "GPL V2",
FILE      = "scape.file",
-------------------------------------------------------------------------------
}

local L = require(_H.PROJECT)
local module = L.module

------------------------------------------------------------------------------

local assert, loadfile, io, string = assert, loadfile, io, string
local _dump = string.dump
local _open = io.open

------------------------------------------------------------------------------
--- <p><b>Module:</b> File operations.
-- </p>
--
module( "scape.file" )
------------------------------------------------------------------------------

module.imports{ 
   "ostream"
}

------------------------------------------------------------------------------

--- Include source into same environment. Works as an replacement for dofile 
-- that takes arguments.
-- @param name name of file
-- @param ... arguments 
-- @return return value of file
function include(name, ...)
   local fname = find(name, _package.path)
   if not fname then _error("not found", 2) end
   local chunk, emsg = _loadfile(fname)
   if not chunk then _error(emsg,2) end
   _setfenv(chunk, _getfenv(2))
   return chunk(...)
end


------------------------------------------------------------------------------
