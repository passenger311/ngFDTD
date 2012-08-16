--[[---------------------------------------------------------------------------
$module      : neolib.collection.DequeSet
$version     : 0.9 
$date        : 8/5/2008
$author      : j.hamm
$license     : x11 
$lua_ver     : 5.1
---------------------------------------------------------------------------]]--
 
      
local class = require "neolib.oop.class"
local table_insert = table.insert
local table_remove = table.remove

local pairs, ipairs, require, assert =  pairs, ipairs, require, assert

--- <p><b>Class:</b> a DequeSet is a double ended queue of set items. Adding
-- an item into the queue which already exists will not alter the state of the
--  queue. A <i>find</i> operation will return an unambiguous result.
-- </p>
--
-- <p><b>Implements:</b>
-- <a href="neolib.collection.Deque.html">Deque</a>,
-- <a href=neolib.collection.IGenericSet.html>IGenericSet</a>
-- </p>
module("neolib.collection.DequeSet")

-------------------------------------------------------------------------------

class.def( _M, 
	   require "neolib.collection.Deque",
	   require "neolib.collection.IGenericSet" )

-------------------------------------------------------------------------------

--- Initializer.
-- @param self instance 
-- @param item_list <i>optional</i> table of items to enqueue
function __init__(self,item_list)
   if item_list then self:fill(item_list) else self:purge() end
end

--- Purge all items from the deque.
-- @param self instance 
function purge(self)
   self.first = 1
   self.last = 0
   self.array = {}
   self.map = {}
end

--- Fill the deque with items from the table.
-- @param self instance 
-- @param item_list a table of items to add
function fill(self,item_list)
   self.array, self.map = {}, {}
   self.first = 1
   self.last = # item_list
   for i,v in ipairs(item_list) do 
      table_insert(self.array, v) 
      self.map[v] = i
   end
end

--- Return the count of a specific item.
-- @param self reference
-- @param item item to count
function countof(self,item)
   if self.map[item] then return 1 else return 0 end
end

--- Create a clone of the deque.
-- @param self instance 
-- @return a clone of the instance.
function clone(self) 
   local nt = class.rawnew(class.of(self))
   nt.array, nt.map = {}, {}
   for i,v in pairs(self.array) do
      nt.array[i] = v
      nt.map[v] = i
   end
   nt.first = self.first
   nt.last = self.last
   return nt
end

--- Pop the right-most item from the deque. 
-- @param self instance 
-- @return item the right-most item
function pop(self)
   local last =  self.last
   if last < self.first then return end
   local item = self.array[last]
   self.array[last] = nil
   self.map[item] = nil
   self.last = last - 1
   return item
end

--- Alias for <i>pop</i>. Pop the right-most item from the deque. 
-- @class function
-- @name enqueue
-- @param self instance 
-- @return item the right-most item
dequeue = pop

--- Push an item into right end of the deque.
-- @param self instance 
-- @param item item to be stored in deque
-- @return position of inserted item
function push(self,item)
   assert(not self.map[item], "item already in deque set!")
   self.last =  self.last + 1
   self.array[self.last] = item
   self.map[item] = self.last
   return self.last
end

--- Pop the left-most item from the deque. 
-- @param self instance 
-- @return item the left-most item
function popleft(self)
   local first =  self.first
   if first >  self.last then return end
   local item = self.array[first]
   self.array[first] = nil
   self.map[first] = nil
   self.first = self.first + 1
   return item
end

--- Push an item into left end of the deque.
-- @param self instance 
-- @param item item to be stored in deque
-- @return position of inserted item
function pushleft(self,item)
   assert(not self.map[item], "item already in deque set!")
   self.first = self.first - 1
   self.array[self.first] = item
   self.map[item] = self.first
   return self.first
end

--- Alias for <i>pushleft</i>. Push an item into left end of the deque.
-- @class function
-- @name dequeue
-- @param self instance 
-- @param item item to be stored in deque
enqueue = pushleft

--- Find an item in the deque and return its position. This is an O(1)
-- operation.
-- @param self instance
-- @param item
-- @return if found the items position, otherwise <i>nil</i>
function find(self,item)
   return self.map[item]
end

--- Check whether deque contains the specified item. This is an O(1)
-- operation.
-- @param self instance
-- @param item
-- @return <i>true</i> if item found, otherwise <i>false</i>
function contains(self,item)
   return self.map[item] ~= nil
end

--- Insert an item at the given position. This is an O(N) operation as the
-- set map needs to be corrected after item insertion.
-- @param self instance
-- @param pos the position
-- @param item the item to be inserted
-- @return position of inserted item
function insert(self,pos,item)
   local map, array = self.map, self.array
   assert(not map[item], "item already in deque set!")
   assert(pos >= self.first and pos <= self.last+1,"index out of range!")
   table_insert(array,pos,item)
   map[item] = pos
   self.last = self.last + 1
   for i=pos+1, self.last do v = array[i]; map[v]=map[v]+1 end
   return pos
end

--- Remove the item at the given position. This is an O(N) operation as the
-- set map needs to be corrected after item removal.
-- @param self instance
-- @param pos the position
function remove(self,pos)
   local map, array = self.map, self.array
   assert(pos >= self.first and pos <= self.last+1,"index out of range!")
   local array = self.array
   self.map[array[pos]] = nil
   table_remove(array,pos)
   self.last = self.last - 1
   for i=pos, self.last do v = array[i]; map[v]=map[v]-1 end
end

--- Merge another set-like instance into the set.
-- @param self instance
-- @param other other set-like instance
function merge(self,other)
   for k,_ in pairs(other.map) do 
      if not self.map[k] then self:push(k) end
   end
end

--- Subtract another set-like instance from the set.
-- @param self instance
-- @param other other set-like instance
function subtract(self,other)
   for k,_ in pairs(other.map) do 
      if self.map[k] then self:remove(self.map[k]) end
   end   
end

--- Intersect another set-like instance with the set.
-- @param self instance
-- @param other other set-like instance
function intersect(self,other)
   for k,v in pairs(self.map) do 
      if not other.map[k] then self:remove(v) end
   end
end

--- Initialize from table which has been created with <i>fromtable()</i>.
-- @class function
-- @name fromtable
-- @param self instance
-- @param table the table from which the instance is to be initialised
function fromtable(self,tab)
   self.array = {}
   self.first = 1
   self.last = #tab
   for i,v in ipairs(tab) do 
      self.array[i] = v 
      self.map[v] = i
   end
end

class.fuse(_M)

-------------------------------------------------------------------------------

