local _H = {
-------------------------------------------------------------------------------
PROJECT   = "xlib",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "14/08/2012 16:01",
COPYRIGHT = "GPL V2",
FILE      = "xlib.struct.bag",
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
--- <p><b>Prototype:</b> an unordered bag of values. </p>
-- The bag holds a maximum of one item of a kind. Adding an item to bag which 
-- is already in the bag will not alter the bag.
-- </p>
module("xlib.struct.bag")
-------------------------------------------------------------------------------

this = proto:_adopt( _M )

--- Create bag and initialize with table.
-- @param tab table of items
-- @return new bag 
function new(tab) 
   local self = this:_adopt{ map = {} }
   if tab then
      return self:add(tab)
   else
      return self
   end
end

--- Purge all items.
-- @param self bag 
-- @return self
function purge(self)
   self.map = {}
   return self
end

--- Create a clone of self.
-- @param self bag 
-- @param object new object [{}]
-- @return clone of bag.
function clone(self, object)
   object = object or {}
   local tab = {}
   for k,v in _pairs(self.map) do tab[k] = v end
   object.map = tab
   return proto.clone(this, object)
end

--- Check whether self is empty.
-- @param self bag 
-- @return <tt>true</tt> if empty; <tt>false</tt> otherwise
function isempty(self)
   return #self.map == 0
end

--- Number of items.
-- @param self bag 
-- @return number of items
function size(self)
   local size = 0
   for _,v in _pairs(self.bag) do size = size + v end
   return size
end

--- Count for specific item.
-- @param self reference
-- @param item item
-- @return count of item
function count(self,item)
   if self.map[item] then
      return self.map[item]
   else
      return 0
   end
end

--- Iterate over items.
-- @param self bag 
-- @return iterator
function items(self)
   local cnt = 0
   local function next(self, item)
      if not item then
	 item, cnt = _next(self.map,nil)
      else
	 cnt = cnt - 1
	 if cnt == 0 then
	    item, cnt = _next(self.map,item)
	 end
      end
      return item, item
   end
   return next, self, nil
end

local function wipe(self)
   local map = self.map
   for k,v in _pairs(map) do
      if v <= 0 then 
	 map[k] = nil 
      end
   end
   return self
end

--- Add item(s) to bag.
-- @param self bag
-- @param other item, table of items, or set/bag
-- @return self 
function add(self,other)
   if other == nil then return end
   local map = self.map
   if _type(other) == 'table' then
      if other.map then
	 for k,v in _pairs(other.map) do 
	    map[k] = ( map[k] or 0 ) + v 
	 end	 
      else
	 for i=1, #other do
	    local k = other[i] 
	    map[k] = ( map[k] or 0 ) + 1 
	 end
      end
   else
      map[other] = ( map[other] or 0 ) + 1
   end
   return self
end

--- Delete from bag.
-- @param self bag
-- @param other item, table of items, or set/bag
-- @return self
function del(self,other)
   if other == nil then return end
   local map = self.map
   if _type(other) == 'table' then
      if other.map then
	 for k,v in _pairs(other.map) do 
	    map[k] = ( map[k] or 0 ) - v 
	 end
      else
	 for i=1, #other do
	    local k = other[i] 
	    map[k] = ( map[k] or 0 ) - 1 
	 end
      end
   else
      map[other] = ( map[other] or 0 ) - 1
   end
   return self:wipe()
end

--- Intersect with other.
-- @param self bag
-- @param other item, table of items or set/bag
-- @return self
function intersect(self,other)
   local map = self.map
   if _type(other) == 'table' then
      if not other.map then
	 other = new( other )
      end
      local omap = other.map
      for k,v in _pairs(map) do 
	 map[k] = v - ( omap[k] or 0 )
      end
   else
      if map[other] then
	 self.map = { other }
      else
	 self.map = {}
      end
   end
   return self:wipe()
end

--- Check whether bag contains item(s).
-- @param self bag 
-- @param other item, table of items or bag
-- @return <i>true</i> if self contains item(s), otherwise <i>false</i>
function contains(self,other)
   local map = self.map
   if _type(other) == 'table' then
      if not other.map then
	 other = new( other )
      end
      for k,v in _pairs(other.map) do
	 if ( map[k] or 0 ) - v <= 0 then 
	    return false 
	 end
      end
   else
      return map[other] ~= nil
   end
   return true
end


--- Return count of item or increment by value.
-- @param self bag 
-- @param key key
-- @param key value (optional)
-- @return item count
function __call(self, key, value)
   if value == nil then
      return self.map[key]
   else
      local value =  self.map[key] + value
      self.map[key] = value
      return value
   end
end

-- Save content into table.
-- @param self bag
-- @return a item table
function totable(self)
   local tab = {}
   for k,v in _pairs(self.map) do tab[k] = v end
   return tab
end

--- Load from table.
-- @param self bag
-- @param tab item table
function fromtable(self,tab)
   local map = {}
   for k,v in _pairs(tab) do map[k] = v end
   self.map = map
   return self
end

--- Create union of two bags.
-- @param a bag
-- @param b other bag
-- @return union of items
function __add(a,b)
   return a:clone():add(b)
end

--- Create difference of two bags.
-- @param self bag
-- @param other other bag
-- @return difference of items
function __sub(a,b)
   return a:clone():remove(b)
end

--- Create intersection of two bags.
-- @param self bag
-- @param other other bag
-- @return intersection of items
function __mul(a,b)
   return a:clone():intersect(b)
end

--- Check whether bag contains item(s).
-- @class function
-- @name __mod
-- @param self bag 
-- @param other item, table of items or bag
-- @return <i>true</i> if self contains item(s), otherwise <i>false</i>
-- @see contains
__mod = contains

--- Build a printable string from bag.
-- @param self bag
-- @return string 
function __tostring(self)
   local tab = {}
   for _,v in self:items() do _table_insert(tab,_tostring(v)) end
   return "{".._table_concat(tab,",").."}"
end




this:_seal()

-------------------------------------------------------------------------------
