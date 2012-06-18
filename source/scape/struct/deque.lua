local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "31/08/2011 12:21",
COPYRIGHT = "GPL V2",
FILE      = "scape.struct.deque",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local proto = L.proto
local table = L.table

-------------------------------------------------------------------------------

local _pairs, _ipairs, _next, _tostring = pairs, ipairs, next, tostring
local _table_insert, _table_concat = table.insert, table.concat
local _min = math.min

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> double ended queue. </p>
-- The deque is optimized to push/pop items at either end.
-- </p>
--
module("scape.struct.deque")
-------------------------------------------------------------------------------

this = proto:_adopt( _M )

first = 1
last = 0
array = {}

--- Create a new deque.
-- @param tab table of items
-- @return instance 
function new(tab) 
   local self = this:_adopt{}
   if tab then
      return self:fill(tab)
   else
      return self
   end
end

--- Purge all items from the deque.
-- @param self instance 
function purge(self)
   self.array = {}
   return self
end

--- Create a clone of the deque.
-- @param self instance 
-- @return a clone of instance.
function clone(self)
   local array = self.array
   local tab = {}
   for i=1,#array do tab[k] = array[i] end
   return proto.clone(this, { array = tab })
end

--- Fill deque with items from the table.
-- @param self instance 
-- @param tab a table of items to add
-- @return self
function fill(self,items) 
   local tab = {}
   for i=1, #items do
      tab[i] = items[i]
   end
   self.array = tab
   self.first = 1
   self.last = #tab
   return self
end

--- Check whether deque is empty or not.
-- @param self instance 
-- @return <tt>true</tt> if empty; <tt>false</tt> otherwise
function isempty(self)
   return self.first > self.last
end

--- Return the number of items in the deque.
-- @param self instance 
-- @return number of items in the deque
function size(self)
   return self.last - self.first + 1
end

--- Return the count for a specific item.
-- @param self reference
-- @param item item to count
function count(self,item)
   local array = self.array
   local c = 0
   for i=self.first, self.last do
      if array[i] == item then c=c+1 end
   end
   return c
end

--- Next item.
-- @param self instance 
-- @param index current index
-- @return next index and item
function next(self,index)
   index = index + 1
   if index > self.last then return end
   return index, self.array[index]
end

--- Itemwise iterator.
-- @param self instance 
-- @return iterator
function items(self)
   return next, self, self.first - 1
end

--- Insert an item into deque.
-- @param self instance
-- @param item item to be put into deque
-- @param pos position
-- @return <tt>true</tt> if insertion succeeded; <tt>false</tt> if failed
function insert(self,item, pos)
   if pos < self.first or pos > self.last+1 then return false end
   _table_insert(self.array,pos,item)
   self.last = self.last + 1
   return true
end

--- Remove an item from set.
-- @param self instance
-- @param item item to be removed
-- @return <tt>true</tt> if item got removed, <tt>false</tt> otherwise
function remove(self,item)
   local c = self.map[item]
   if c then
      if c == 1 then
	 self.map[item] = nil
      else
	 self.map[item] = c - 1
      end
      return true
   else
      return false
   end
end

--- Merge other deque into the deque.
-- @param self instance
-- @param other other deque
-- @return self
function merge(self,other)
   local map = self.map
   for k,v in _pairs(other.map) do 
      local c = map[k] or 0
      map[k] = c + v 
   end
   return self
end

--- Substract other deque from the deque.
-- @param self instance
-- @param other other deque
-- @return self
function substract(self,other)
   local map = self.map
   for k,v in _pairs(other.map) do 
      local c = map[k] or 0
      if c > v then
	 map[k] = c-v
      else
	 map[k] = nil
      end
   end 
   return self
end

--- Intersect the set with other set.
-- @param self instance
-- @param other other set
-- @return self
function intersect(self,other)
   local map = self.map
   other = other.map
   for k,v in _pairs(map) do
      local c = other[k] or 0
      c = _min(c,v)
      if c > 0 then
	 map[k] = c
      else
	 map[k] = nil
      end
   end
   return self
end

--- Check whether for an item inside the set.
-- @param self instance 
-- @param item item
-- @return <i>true</i> if item is found, otherwise <i>false</i>
function contains(self,item)
   return self.map[item] ~= nil
end

--- Find an item within the set.
-- @param self instance
-- @param item the item to look for in the set
-- @return the item itself if found; <tt>nil</tt> otherwise
function find(self,item)
   if self.map[item] then return item else return end
end

-- Create a compact table from set.
-- @param self instance
-- @return a table which contains the set content
function totable(self)
   local tab = {}
   for k,v in _pairs(self.map) do tab[k] = v end
   return tab
end

--- Initialize from compact table.
-- @param self instance
-- @param tab table
-- @return self
function fromtable(self,tab)
   local map = {}
   for k,v in _pairs(tab) do map[k] = v end
   self.map = map
   return self
end

--- Create union of two sets.
-- @param self instance
-- @param other other set
-- @return union set
function __add(a,b)
   return a:clone():merge(b)
end

--- Create difference of two sets.
-- @param self instance
-- @param other other set
-- @return difference set
function __sub(a,b)
   return a:clone():subtract(b)
end

--- Create intersection of two sets.
-- @param self instance
-- @param other other set
-- @return intersection set
function __mul(a,b)
   return a:clone():intersect()
end

--- Build a printable string from set.
-- @param self instance
-- @return string 
function __tostring(self)
   local tab = {}
   for _,v in self:items() do _table_insert(tab,_tostring(v)) end
   return "[".._table_concat(tab,",").."]"
end

this:_seal()

-------------------------------------------------------------------------------
