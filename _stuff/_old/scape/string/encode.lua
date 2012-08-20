local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "31/08/2011 12:21",
COPYRIGHT = "GPL V2",
FILE      = "scape.string.encode",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module

-------------------------------------------------------------------------------

local _string, _table, _pairs, _ipairs, _tonumber, _math, _os, _print, _require
   =  string, table, pairs, ipairs, tonumber, math, os, print, require
local _insert, _concat, _char, _format, _random
   = table.insert, table.concat, string.char, string.format, math.random
local _floor =  math.floor
local _mime = module.load("mime")

-------------------------------------------------------------------------------
--- <p><b>Module:</b> utilities for string encoding.</p>
--
module("scape.string.encode")
------------------------------------------------------------------------------

local base64enctable = 
   { [0]="A","B","C","D","E","F","G","H","I","J","K","L","M",
     "N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a",
     "b","c","d","e","f","g","h","i","j","k","l","m","n","o",
     "p","q","r","s","t","u","v","w","x","y","z","0","1","2",
     "3","4","5","6","7","8","9","+","/" }

------------------------------------------------------------------------------

--- Encode a byte sequence into a hexadecimal string.
-- @param str byte sequence
-- @return hexadecimal string
function hex( str )
   local fct = function(c) return _format("%02x", c:byte() ) end
   local ret = str:gsub(".",fct)
   return ret
end

--- Decode a hexadecimal string into a byte sequence.
-- @param str hexadecimal string
-- @return byte sequence
function unhex( str )
   if #str % 2 ~= 0 then return nil end
   local fct = function(h) return _char(_tonumber(h,16)) end
   local ret = str:gsub( "(%x%x)", fct )
   if #ret == #str/2 then
      return ret
   else
      return nil
   end
end

--- Encode a byte sequence into a base-64 string. 
-- Requires <i>'luasocket'</i>.
-- @param str byte sequence
-- @return base-64 string
function b64(str)
   local ret, err = _mime.b64(str)
   return ret
end

--- Decode base-64 string into a byte sequence.
-- Requires <i>'luasocket'</i>.
-- @param str base-64 string
-- @return byte sequence
function unb64(str)
   local ret,err = _mime.unb64(str)
   return ret
end

--- Create a random string of base-64 characters. Consider using 
-- <i>randomseed(os.time())</i> to seed random generator prior to use. 
-- @param length number of characters
-- @return string of given length
function ranb64(length)
   local t = {}
   for i=1, length do
      _insert(t,base64enctable[_random(0,63)])
   end
   return _concat(t)
end

--- Create a random string of hexadecimal characters. Consider using 
-- <i>randomseed(os.time())</i> to seed random generator prior to use. 
-- @param len number of characters
-- @return string of given length
function ranhex(len)
   local t = {}
   for i=1, _floor(len/8)*8, 8 do
      _insert(t,_format("%04x%04x",
			_random(0,65536),_random(0,65536)))
   end
   for i=1, len%8 do
      _insert(t,_format("%01x",_random(0,15)))   
   end
   return _concat(t)
end


------------------------------------------------------------------------------
