local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2",
FILE      = "ffi",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module

-------------------------------------------------------------------------------

local _string, _table, _pairs, _ipairs, _unpack, _getmetatable, _type, _package
   =  string, table, pairs, ipairs, unpack, getmetatable, type, package
local _insert, _concat, _loadstring, _assert, _format
   = _table.insert, _table.concat, loadstring, assert, _string.format
local _tonumber = tonumber

-------------------------------------------------------------------------------
--- <p><b>Module:</b> ffi library extensions. </p>
--
module( "scape.ffi" )
------------------------------------------------------------------------------

module.extends("ffi")
module.imports{

}

------------------------------------------------------------------------------

--- Read declarations from header file.
-- @param file filename
-- @return header string.
function getdecl(file)


end


------------------------------------------------------------------------------
