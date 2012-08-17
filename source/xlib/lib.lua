local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.lib",
VERSION   = "0.1",
DATE      = "17/08/2012 16:29",
COPYRIGHT = "(C) 2012",
-------------------------------------------------------------------------------
}

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
---<p><b>Module</b>: Library tools. </p>
--
module( "xlib.lib" )
-------------------------------------------------------------------------------

DIRSEP = _G.package.config:gsub("\n.*$","")
PATH_MARK = '?'
NAME = _NAME:gsub("%..*$","")
IS_JIT = not not _G.jit


local function _find(name, path)
   name = _gsub(name, "%.", DIRSEP)
   _assert(_type(path) == "string")
   for c in _gfind (path, "[^;]+") do
      c = _gsub(c, "%"..PATH_MARK, name)
      local f = _open(c)
      if f then
	 f:close()
	 return c
      end
   end
   return nil -- not found
end

--- Check for source or binary library in path.
-- @param name name of library
-- @return path encoded path or <tt>nil</tt> to search Lua path
-- @return fully qualified file path to library or <tt>nil</tt>
function find(name,path)
   if not path then
      return _find(name,_package.path) or find(name,_package.cpath)
   else
      return _find(name,path)
   end
end
 
--- Include source into same environment. A replacement for dofile that takes
-- arguments.
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

--- Load library (libraries) or return <tt>nil</tt>.
-- @param names name of library, or table of names of libraries to load
-- @return library reference or table of library references.
function load(names)
   if _type(names) == 'string' then
      local ok, ret = _pcall( _require, names )  
      if ok then return ret else return nil end
   else
      local tab = {}
      for i=1, #names do
	 local m = names[i]
	 local k = m:gsub("%%.","_")
	 local v = load(m)
	 tab[k] = v
      end
      return tab
   end
end   

--- Import all components listed in M._IMPORT into module table.
-- @param M module
-- @return M
function import( M )
   local names = M._IMPORT or {}
   local prefix = M._NAME
   for i=1, #names do
      local m = names[i]
      local name = prefix.."."..m
      local ret = _require( name )  
      _assert(_type(ret) == 'table', "require failed on "..name)
      if ret.import and ret._IMPORT then
	 ret.import()
      end
      M[m] = ret 
   end
   return M
end

local function _getcomps( name, tab )
   local ok,ret = _pcall(_require,name)
   if ok and _type(ret) == 'table' then
      local prefix = ret._NAME
      local names = ret._IMPORT or {}
      for i=1, #names do
	 --      _print(prefix.."."..names[i])
	 _getcomps(prefix.."."..names[i],tab)
      end
   end
   tab[name] = ret
   return tab
end

--- Get all components.
-- @return table of modules
function getcomps( name )
   return _getcomps( name, {} )
end

--- Autoloader __index function.
-- @param self table
-- @param key key
-- @return self[key]
function autoloader(self, key)
   local prefix = self._NAME
   local ret = _assert(_require( prefix.."."..key ))  
   self[key] = ret
   return ret 
end

--- Enable module for automatic import.
-- @param M module
-- @return M
function autoimport(M)
   local tab = _getmetatable(M) or {}
   tab.__index = autoloader
   _setmetatable(M, tab)
   return M
end


------------------------------------------------------------------------------


