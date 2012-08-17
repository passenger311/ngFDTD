
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
module( "run.lib" )
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



------------------------------------------------------------------------------


