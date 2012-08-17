local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.2",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2",
FILE      = "scape.string.stream",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local proto = L.proto
local utils = L.utils

-------------------------------------------------------------------------------

local _G, _string, _table, _select, _type, _pairs, _ipairs, _assert, _require, _print
   =  _G, string, table, select, type, pairs, ipairs, assert, require, print

----------------------------------------------------------------------------
--- <p><b>Prototype:</b> String stream. </p>
-- A string stream emulates operations of the standard lua file handler.
-- </p>
module( "scape.string.stream" )
----------------------------------------------------------------------------

this = proto.clone( proto.root, _M )

--- Create string stream.
-- @param str string
-- @param mode read/write mode: "r", "w", "r+", "w+", "a+" (optional)
-- @return new string stream
function new(str, mode)
   local rmode, wmode
   if mode:sub(1,1) == "r" or  mode:sub(2,2) == "+" then
      rmode = true
   end
   if mode:sub(1,1) == "w" or  mode:sub(1,1) == "a" then
      wmode = true
   end
   local ret = proto.clone(this, { wmode = wmode, rmode = rmode, 
				   pos = 0, str = str } )
   return ret
end

--- Read from string.
-- @param self stream
-- @param mode read mode, "*l", "*a", "*n" or number of characters
-- @return string; or <tt>nil</tt> if eos
function read(self, mode)
   _assert(self.rmode)
   mode = mode or "*l"
   mode = mode:sub(1,2)
   str = self.str:sub(pos+1)
   if mode == "*l" then
      local f,t = str:find("^.*\n")
      self.pos = t
      return str:sub(f,t)
   elseif mode == "*a" then
      self.pos = # self.str
      return str
   elseif mode == "*n" then
      local f,t = str:find)(utils.FLOAT)
      self.pos = t
      return str:sub(f,t)
   else -- number
      local f = self.pos+1
      local t = _max( f + mode, # str )
      self.pos = t
      return str:sub(f,t)
   end
end

--- Seek position.
-- @param self stream
-- @param pos position
-- @return pos if ok; <tt>false</tt> otherwise
function seek(self, pos)
   if pos < 1 or pos > #self.str then 
      return nil 
   end
   self.pos = pos
   return pos
end

--- Write to string.
-- @param self stream
-- @param 
function write(self)

end


function setvbuf(self,...)
   return self
end


function lines(self)

end


proto.seal(_M)

----------------------------------------------------------------------------
