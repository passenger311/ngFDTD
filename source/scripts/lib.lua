
local _G, _PACKAGE, _LOADED = _G, _G.package, _G.package.loaded
local _require, _pcall, _pairs, _assert, _type, _select, _setfenv, _loadfile
   = require, pcall, pairs, assert, type, select, setfenv, loadfile
local _ipairs = ipairs
local _getmetatable, _setmetatable = getmetatable, setmetatable
local _error, _getfenv, _print, _tostring = error, getfenv, print, tostring
local _package, _loaded, _module = package, package.loaded, module
local _gsub, _gfind, _format = string.gsub, string.gfind, string.format
local _string = string
local _insert = table.insert
local _open = io.open

-------------------------------------------------------------------------------
---<p><b>Module</b>: Library tools. </p>
--
module( "scripts.lib" )
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


--- merge tables
function merge( ... )
	 local t = {}
	 for i=1,_select('#',...) do
	     local s = _select(i,...)
	     for _,v in _ipairs(s) do
	     	 _insert(t,v)
	     end
	 end
	 return t
end

local PREFIX   = "LUAOPEN_API"
local FUNC_SEP = "_"

------------------------------------------------------------------------------

local function getbytecode(filepath)
   local filepath = filepath:gsub("%.",DIRSEP)
   local filename = filepath..".lua"
   local file = _open(filepath..".lua")
   _assert(file,"could not open "..filename)
   file:close()
   return _string.dump(_assert(_loadfile(filename)))
end

------------------------------------------------------------------------------

function precompile(inputs, libname, outdir)
   outdir = outdir:gsub("%.",DIRSEP)
   local outc = _assert(_open(outdir..DIRSEP..libname..".c", "w"))
   local outh = _assert(_open(outdir..DIRSEP..libname..".h", "w"))

   local guard = libname:upper():gsub("[^%w]", "_")

-- write <libname>.h file

   outh:write([[
#ifndef __]],guard,[[__
#define __]],guard,[[__

#include <lua.h>

#ifndef ]],PREFIX,[[ 
#define ]],PREFIX,[[ 
#endif

]])
   
-- write <libname>.c file

   outc:write([[
#include <lua.h>
#include <lauxlib.h>
#include "]],libname,[[.h"

]])

   local i = 0
   for _,input in _ipairs(inputs) do
      i = i + 1
      local bytecode = getbytecode(input)
      outc:write("static const unsigned char B",i,"[]={\n")
      for j = 1, #bytecode do
	 outc:write(_string.format("%3u,", bytecode:byte(j)))
	 if j % 20 == 0 then outc:write("\n") end
      end
      outc:write("\n};\n\n")
   end

   local i = 0
   for _,input in _ipairs(inputs) do
      i = i + 1
      local func = input:gsub("%.", FUNC_SEP)
      outh:write(PREFIX," int luaopen_",func,"(lua_State *L);\n")
      outc:write(PREFIX,[[ int luaopen_]],func,[[(lua_State *L) {
  int arg = lua_gettop(L);
  luaL_loadbuffer(L,(const char*)B]],i,[[,sizeof(B]],i,[[),"]],input,[[");
  lua_insert(L,1);
  lua_call(L,arg,1);
  return 1;
}

]])
   end

   outh:write([[

#endif /* __]],guard,[[__ */

]])

   outh:close()
   outc:close()

end

------------------------------------------------------------------------------

function preloader(inputs, ldrname, outdir)

outdir = outdir:gsub("%.",DIRSEP)

local funcname = ldrname

-- write <ldrname>.h file

local outh = _assert(_open(outdir..DIRSEP..ldrname..".h", "w"))

local guard = ldrname:upper():gsub("[^%w]", "_")

outh:write([[
#ifndef __]],guard,[[__
#define __]],guard,[[__

#ifndef ]],PREFIX,[[ 
#define ]],PREFIX,[[ 
#endif

]],PREFIX,[[ int ]],funcname,[[(lua_State *L);

#endif /* __]],guard,[[__ */
]])
outh:close()


-- write <ldrname>.c file

local outc = _assert(_open(outdir..DIRSEP..ldrname..".c", "w"))
outc:write([[
#include <lua.h>
#include <lauxlib.h>

]])

for _, input in _ipairs(inputs) do
   outc:write('int luaopen_',input:gsub("%.", FUNC_SEP),'(lua_State*);\n')
end

outc:write([[

#include "]],ldrname,[[.h"

]],PREFIX,[[ int ]],funcname,[[(lua_State *L) {
	luaL_findtable(L, LUA_GLOBALSINDEX, "package.preload", ]], #inputs, [[);
	
]])
local code = [[
	lua_pushcfunction(L, luaopen_%s);
	lua_setfield(L, -2, "%s");
]]
for _, input in _ipairs(inputs) do
   outc:write(code:format(input:gsub("%.", FUNC_SEP), input))
end
outc:write([[
	
	lua_pop(L, 1);
	return 0;
}
]])

outc:close()

end



------------------------------------------------------------------------------


