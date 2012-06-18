local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "31/08/2011 12:21",
COPYRIGHT = "GPL V2",
FILE      = "scape.module",
-------------------------------------------------------------------------------
}

local _G = _G
local _require, _pcall, _pairs, _assert, _type, _setfenv, _loadfile
   = require, pcall, pairs, assert, type, setfenv, loadfile
local _getmetatable, _setmetatable = getmetatable, setmetatable
local _error, _getfenv, _print, _tostring = error, getfenv, print, tostring
local _package, _loaded = package, package.loaded
local _gsub, _gfind, _format = string.gsub, string.gfind, string.format
local _insert, _open = table.insert, io.open
local _module, _select = module, select

-------------------------------------------------------------------------------
---<p><b>Module</b>: Smart module handler. </p>
--
module( "scape.module" )
-------------------------------------------------------------------------------

policy = {
   AUTOLOAD = true,
   PRELOAD = false
}

loaded = {}

DIRSEP = _G.package.config:gsub("\n.*$","")
PATH_MARK = '?'
NAME = _NAME:gsub("%..*$","")
IS_JIT = not not _G.jit

_setmetatable(_M,_M)
_M.index = _M

__call = function(self, modname, ... )
   local ns = _loaded[modname]
   if ns ~= 'table' then 
      ns = {} 
      _loaded[modname] = ns
   end
   ns._M = ns
   ns._NAME = modname
   _setfenv(2,ns)
   for i=1,_select('#',...) do 
      _select(i,...)(ns)
   end
   return ns
end

--- Split module name into fragments.
-- @param name module name
-- @return array of name
function namesplit(name)
   local res = {}
   for f in name:gmatch("[^%.]+") do
      _insert(res, f)
   end
   return res
end

local function findpath(name, path)
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
      return findpath(name,_package.path) or findpath(name,_package.cpath)
   else
      return findpath(name,path)
   end
end
 
--- Load library (libraries) or return <tt>nil</tt>. Similar to require but
-- can do cluster load into table and does not throw error.
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

local function hashify(list)
   for i=1,#list do
      local k = list[i]
      list[k] = true
   end
end

--- Install autoloader() and import() functions for current module.
-- @param list list of child component names
function imports(list)
   local M = _getfenv(2)
   M._IMPORT = list
   local _NAME = M._NAME -- make copy of _NAME as this may be cleared.
   hashify(M._IMPORT)
   local meta = _getmetatable(M) or {}
   local function autoloader(self, key)
      if M._IMPORT[key] and policy.AUTOLOAD then
	 local name = _NAME.."."..key
	 local ret = _require(name)  
	 _assert(_type(ret) == 'table', "failed loading "..name)
	 loaded[name] = ret
	 M[key] = ret
	 return ret 
      end
   end
   meta.__index = autoloader
   _setmetatable(M, meta)
   local function importer()
      for i=1, #M._IMPORT do
	 local m = M._IMPORT[i]
	 local name = _NAME.."."..m
	 local ret = _require( name )  
	 _assert(_type(ret) == 'table', 
		 "module "..name.." did not return table")
	 loaded[name] = ret
	 if ret.import then
	    ret.import()
	 end
	 M[m] = ret 
      end
   end
   M.import = importer
   if policy.PRELOAD then M.import() end
end

--- Extend current module with content of package.
-- @param name package name
function extends(name)
   local M = _getfenv(2)
   for k,v in _pairs(_loaded[name]) do 
      if not M[k] then 
	 M[k] = v 
      else
	 _error(_format("extend: collision %s <- %s"), 
		M[k], name..".".._tostring(v))
      end
   end
end


------------------------------------------------------------------------------


