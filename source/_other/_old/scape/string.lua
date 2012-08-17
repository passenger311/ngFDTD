local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "31/08/2011 12:21",
COPYRIGHT = "GPL V2",
FILE      = "scape.string",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local proto = L.proto

-------------------------------------------------------------------------------

local _string, _table, _pairs, _ipairs, _unpack, _getmetatable, _type, _package
   =  string, table, pairs, ipairs, unpack, getmetatable, type, package
local _insert, _concat, _loadstring, _assert, _format
   = _table.insert, _table.concat, loadstring, assert, _string.format
local _tonumber, _tostring = tonumber, tostring

-------------------------------------------------------------------------------
--- <p><b>Module:</b> String extensions. </p>
--
module( "scape.string" )
------------------------------------------------------------------------------

module.extends("string")

module.imports{ 
   "encode",
   "version"
}

------------------------------------------------------------------------------

--- Split string. Partition string into a number of fragments using the 
-- specified delimiter. If the maximum number of fragments is set to 
-- <tt>nil</tt> then the string will be completely partitioned.
-- @param str string to split
-- @param delim delimiter string or pattern [" "]
-- @param plain use plain matching for delimiter [<tt>false</tt>]
-- @param maxnum maximum number of partitions [<i>str:len()</i>]
-- @return <i>table</i> of fragments
function split( str, delim, plain, maxnum )
   delim = delim or " "
   local tab = {}
   local l = str:len()
   local n = maxnum or l
   local b,e = str:find(delim, 1, plain)
   while b and n > 0 do 
      if b > 1 then _insert(tab,str:sub(1,b-1)) end
      str = str:sub(e+1,l)
      n = n - 1
      l = l - e 
      b,e = str:find(delim,1,plain)
   end
   if str ~= "" then _insert(tab,str) end
   return tab
end

--- Reverse string.
-- @param str string
-- @return reverse of string
function reverse( str )
   local tab = {}
   local l = str:len()
   for i=l,1,-1 do
      _insert(tab,str:sub(i,i))
   end
   return _concat(tab)
end

--- Trim trailing whitespaces.
-- @param str string
-- @return result string
function rtrim( str )
   return str:gsub("%s+$","")
end

--- Trim leading whitespaces.
-- @param str string
-- @return result string
function ltrim( str )
   return str:gsub("^%s+","")
end

--- Trim trailing and leading whitespaces.
-- @param str string
-- @return result string
function trim( str )
   return str:gsub("^%s+",""):gsub("%s+$","")
end

--- Chop off last character in string.
-- @param str string
-- @return result string
function chop( str )
   return str:sub(1,-2)
end

--- Get number from beginning of string.
-- @param str string
-- @return number and character count
function getnumber(str)
   local f,c = str:find("[%+%-%d]%d*%.?%d*[eE]?[%+%-]?%d*")
   if not f then return nil end
   f = _tonumber(str:sub(f,c))
   if f then
      return f, c
   end
end

--- Get identifier from beginning of string.
-- @param str string
-- @param ttab token tablex
-- @return token and character count
function getiden(str, ttab)
   local f,c = str:find("[%a_][%w_]*")
   if f then 
      return f, c
   end
end

--- 
local function _replace(str,tab)
   if _type(tab) ~= "table" then return str end
   local function fct(k, fmt) 
      return ( tab[k] and ("%"..fmt):format(tab[k]) or 
	 '${'..k..':'..fmt..'}' )
   end
   local ret = str:gsub('%%%{(%a%w*)%:([-0-9%.]*[cdeEfgGiouxXsq])%}', fct )
   return ret
end

--- String interpolation. 
-- @param str string
-- @param arg argument table (or single scalar argument) 
-- @return result string
function interpolate(str, arg)
   if not arg then
      return str
   elseif _type(arg) == "table" then
      return _format(_replace(str,arg), _unpack(arg))
   else
      return _format(str, arg)
   end
end

_getmetatable("").__mod = interpolate

--- Compile a chunk of source code from a string 
-- @param string a string which contains a chunk of lua source code
-- @return byte-code string
function compilestring(string)
   return _string.dump(_assert(_loadstring(string)))
end

------------------------------------------------------------------------------
