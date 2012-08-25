local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.file",
VERSION   = "0.1",
DATE      = "18/08/2012 16:09",
COPYRIGHT = "(C) 2012 NEO·LIGHT Project",
-------------------------------------------------------------------------------
}


local xlib = require( "xlib" )
local module = xlib.module

-------------------------------------------------------------------------------

local _G, _PACKAGE, _LOADED = _G, _G.package, _G.package.loaded
local _require, _pcall, _pairs, _assert, _type, _select, _setfenv, _loadfile
   = require, pcall, pairs, assert, type, select, setfenv, loadfile
local _getmetatable, _setmetatable = getmetatable, setmetatable
local _error, _getfenv, _print, _tostring = error, getfenv, print, tostring
local _package, _loaded, _module = package, package.loaded, module
local _gsub, _gfind, _format = string.gsub, string.gfind, string.format
local _insert = table.insert
local _open = io.open

-------------------------------------------------------------------------------
---<p><b>Module</b>: File tools. </p>
--
module( _H.FILE )
-------------------------------------------------------------------------------

module.imports{ 
}

-------------------------------------------------------------------------------

DIRSEP = _G.package.config:gsub("\n.*$","")

--- A dofile version that takes arguments.
-- @param name name of file
-- @param ... arguments 
-- @return return value of file
function include(name, ...)
   local chunk, emsg = _loadfile(name)
   if not chunk then _error(emsg,2) end
   _setfenv(chunk, _getfenv(2))
   return chunk(...)
end

--- Check whether file exists.
-- @param name name of file
-- @param ... arguments 
-- @return <tt>true</tt> if file exists, <tt>false</tt> otherwise
function exists(name)
   local name = name:gsub("%/",DIRSEP):gsub("\\",DIRSEP)
   local file = _open(name)
   if file then
      file:close()
      return true
   end
   return false
end

------------------------------------------------------------------------------


