local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "31/08/2011 12:21",
COPYRIGHT = "GPL V2",
FILE      = "scape.struct.set",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local proto = L.proto
local table = L.table

-------------------------------------------------------------------------------

local _pairs, _ipairs, _next, _tostring = pairs, ipairs, next, tostring
local _table_insert, _table_concat = table.insert, table.concat
local _type = type

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> an unordered set of values. </p>
-- The set holds a maximum of one item of a kind. Adding an item to set which 
-- is already in the set will not alter the set.
-- </p>
module("scape.struct.set")
-------------------------------------------------------------------------------

this = proto:_adopt( _M )

--- Create set and initialize with table.
-- @param tab table of items
-- @return new set 
function new(tab) 
   local self = this:_adopt{ map = {} }
   if tab then
      return self:add(tab)
   else
      return self
   end
end

--- Purge all items.
-- @param self set 
-- @return self
function purge(self)
   self.map = {}
   return self
end

--- Create a clone of self.
-- @param self set 
-- @param object new object [{}]
-- @return clone of set.
function clone(self, object)
   object = object or {}
   local tab = {}
   for k,_ in _pairs(self.map) do tab[k] = 1 end
   object.map = tab
   return proto.clone(this, object)
end

--- Check whether self is empty.
-- @param self set 
-- @return <tt>true</tt> if empty; <tt>false</tt> otherwise
function isempty(self)
   return #self.map == 0
end

--- Number of items.
-- @param self set 
-- @return number of items
function size(self)
   local size = 0
   for _,_ in _pairs(self.map) do size = size + 1 end
   return size
end

--- Count for specific item.
-- @param self reference
-- @param item item
-- @return count of item
function count(self,item)
   if self.map[item] then
      return 1
   else
      return 0
   end
end

local function next(self, index)
   index = _next(self.map,index)
   return index, index
end

--- Iterate over items.
-- @param self set 
-- @return iterator
function items(self) 
   return next, self, nil
end

--- Add item(s) to set.
-- @param self set
-- @param other item, table of items, or set/bag
-- @return self 
function add(self,other)
   if other == nil then return end
   local map = self.map
   if _type(other) == 'table' then
      if other.map then
	 for k in _pairs(other.map) do 
	    map[k] = 1 
	 end	 
      else
	 for i=1, #other do 
	    map[other[i]] = 1 
	 end
      end
   else
      self.map[other] = 1
   end
   return self
end

--- Delete from set.
-- @param self set
-- @param other item, table of items, or set/bag
-- @return self
function del(self,other)
   if other == nil then return end
   local map = self.map
   if _type(other) == 'table' then
      if other.map then
	 for v in _pairs(other.map) do 
	    map[v] = nil 
	 end	 
      else
	 for _,v in _ipairs(other) do 
	    map[v] = nil 
	 end
      end
   else
      map[other] = nil
   end
   return self
end

--- Intersect with other.
-- @param self set
-- @param other item, table of items or set/bag
-- @return self
function intersect(self,other)
   local map = self.map
   if _type(other) == 'table' then
      if not other.map then
	 other = new( other )
      end
      local omap = other.map
      for k,_ in _pairs(map) do 
	 if not omap[k] then 
	    map[k] = nil 
	 end
      end
   else
      if map[other] then
	 self.map = { other }
      else
	 self.map = {}
      end
   end
   return self
end

--- Check whether set contains item(s).
-- @param self set 
-- @param other item, table of items or set
-- @return <i>true</i> if self contains item(s), otherwise <i>false</i>
function contains(self,other)
   local map = self.map
   if _type(other) == 'table' then
      if other.map then
	 for k in _pairs(other.map) do
	    if not map[k] then return false end
	 end
      else
	  for _,k in _ipairs(other) do
	    if not map[k] then return false end
	 end
      end
   else
      return map[other] ~= nil
   end
   return true
end

--- ??? THIS WILL OVERRIDE PARENT'S __CALL
--- Return count of item or increment by value.
-- @param self bag 
-- @param key key
-- @param key value (optional)
-- @return item count
function __call(self, key, value)
   if value == nil then
      return self.map[key]
   else
      self.map[key] = 1
      return 1
   end
end

-- Save content into table.
-- @param self set
-- @return a item table
function totable(self)
   local tab = {}
   for k,_ in _pairs(self.map) do _table_insert(tab,k) end
   return tab
end

--- Load from table.
-- @param self set
-- @param tab item table
function fromtable(self,tab)
   local map = {}
   for k,v in _pairs(tab) do map[k] = 1 end
   self.map = map
   return self
end

--- Create union of two sets.
-- @param a set
-- @param b other set
-- @return union of items
function __add(a,b)
   return a:clone():add(b)
end

--- Create difference of two sets.
-- @param self set
-- @param other other set
-- @return difference of items
function __sub(a,b)
   return a:clone():remove(b)
end

--- Create intersection of two sets.
-- @param self set
-- @param other other set
-- @return intersection of items
function __mul(a,b)
   return a:clone():intersect(b)
end


--- Check whether set contains item(s).
-- @class function
-- @name __mod
-- @param self set 
-- @param other item, table of items or set
-- @return <i>true</i> if self contains item(s), otherwise <i>false</i>
-- @see contains
__mod = contains

--- Build a printable string from set.
-- @param self set
-- @return string 
function __tostring(self)
   local tab = {}
   for v in self:items() do _table_insert(tab,_tostring(v)) end
   return "{".._table_concat(tab,",").."}"
end

this:_seal()

-------------------------------------------------------------------------------
