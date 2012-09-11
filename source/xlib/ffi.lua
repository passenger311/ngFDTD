local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.ffi",
VERSION   = "0.1",
DATE      = "18/08/2012 16:09",
COPYRIGHT = "(C) 2012 NEO·LIGHT Project",
-------------------------------------------------------------------------------
}

local _G = _G
local ffi = require("ffi")
local xlib = require( "xlib" )
local string = xlib.string
local table = xlib.table
local module = xlib.module

-------------------------------------------------------------------------------

local _pcall = pcall
local _assert, _error = assert, error
local _print = print

-------------------------------------------------------------------------------
--- <p><b>Module:</b> ffi utility library. </p>
--
module( _H.FILE )
-------------------------------------------------------------------------------

module.extends("ffi")

module.imports{ 
   nil
}

local funpat= "([%s%w_]+)%s([%w_]+)%s*(%(?.-%)?)%s*;%s*"

--- Get parts of declaration. First is return type, second is name of symbol,
-- third is argument of symbol 
-- @param lib library
-- @param cdecl symbol declaration
-- @return (ret, name, arg) parts of symbol or <tt>nil</tt> 
function getdeclparts(cdecl)
   return cdecl:match(funpat)
end

local function _getsymref(lib, name)
   return lib[name]
end

--- Get reference to symbol in loaded ffi library. 
-- @param lib library
-- @param name name of symbol
-- @return reference to symbol or <tt>nil</tt> 
function getsymref(lib, name)
   local ok, ref = _pcall(_getsymref, lib, name)
   if ok then
      return ref
   end
end

--- Get reference to symbol in loaded ffi library. 
-- @param lib library
-- @param ret return type of symbol
-- @param name name of symbol
-- @param arg arguments of symbol
-- @return reference to symbol or <tt>nil</tt> 
function getsymdef(lib, ret, name, arg)
   local def = ret.." "..name..arg..";" 
   ffi.cdef(def)
   return getsymref(lib,name)
end

--- Figure out naming convention of symbols defined by Fortran in library.
-- @param cdecl symbol declaration
-- @param lib library
-- @return name wrapper function
function getf77wrapfun(lib, cdecl)
   _assert(lib, "arg1 (lib) is nil")
   local ret, name, arg = getdeclparts(cdecl);
   local lname = string.lower(name)
   local uname = string.upper(name)
   -- try to access symbols. Use most common first to not clutter namespace 
   -- with invalid cdefs.
   if getsymdef(lib,ret, lname.."_", arg) then
      return function(name) return string.lower(name).."_" end
   elseif getsymdef(lib, ret, lname, arg) then
      return function(name) return string.lower(name) end
   elseif getsymdef(lib, ret, uname, arg) then
      return function(name) return string.upper(name) end
   elseif getsymdef(lib, ret, uname.."_", arg) then
      return function(name) return string.upper(name).."_" end
   -- extend list as needed
   else
      _error("failed to figure out Fortran calling convention")
   end
end

function wrapf77defs(lib, extern_decls)
   -- figure out Fortran name convention
   local wrapfun = getf77wrapfun(lib,extern_decls)
   local defs = extern_decls:gsub(funpat, function(r,n,a)
					     n = wrapfun(n)
					     return r.." "..n..a..";\n"
					  end )
   _print(defs)
   return ffi.cdef( defs )
end 

--- Try ffi.load with a number of library names.
function tryload(names, global)
   local ok, libs = nil, {}
   for i=1,#names do
      ok, libs[i] = _pcall( ffi.load, names[i], global )		   
--      _print(ok, libs[i])
      if not ok then
	 libs[i] = false
      end
   end
   return libs
end	


-------------------------------------------------------------------------------
