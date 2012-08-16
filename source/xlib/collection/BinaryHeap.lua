--[[---------------------------------------------------------------------------
$module      : xlib.collection.BinaryHeap
$version     : 0.9 
$date        : 8/5/2008
$author      : j.hamm
$license     : x11 
$lua_ver     : 5.1
---------------------------------------------------------------------------]]--
    
local class = require "xlib.oop.class"
local table_utils = require "xlib.util.table"
local toint = math.floor
local table_remove = table.remove

local pairs, ipairs, require, assert = pairs, ipairs, require, assert

--- <p><b>Class:</b> 
-- fast and efficient implementation of a binary heap priority queue. All
-- items stored in the queue must provide an implementation of the "<"
-- (__lt) operator. 
-- <p>
--
-- <p><b>Implements:</b> 
-- <a href=xlib.collection.IGenericPriorityQueue.html>IGenericPriorityQueue</a>,
-- <a href=xlib.generic.ICloneable.html>ICloneable</a>
-- </p>
--
module("xlib.collection.BinaryHeap")

-------------------------------------------------------------------------------

class.def( _M, 
	   require "xlib.collection.IGenericPriorityQueue",
	   require "xlib.generic.ICloneable" )

-------------------------------------------------------------------------------

--- Initializer.
-- @param self instance 
-- @param item_list <i>optional</i> table of items to enqueue
function __init__(self, item_list)
   if item_list then self:fill(item_list) else self:purge() end 
end

--- Purge all items from binary heap, leaving it empty.
-- @param self instance 
function purge(self)
   self.array = {}
   self.map = {}
end

--- Check whether binary heap is empty or not.
-- @param self instance 
-- @return <i>true</i> or <i>false</i> depending on whether binary heap is 
-- empty or not
function isempty(self)
   return # self.array == 0
end

--- Return the number of items in the binary heap.
-- @param self instance 
-- @return number of items in the binary heap
function count(self)
   return # self.array
end

--- Return an iterator which allows to loop over all items inside the binary
-- heap in no particular order. 
-- @param self instance 
-- @return <i>pairs</i> type iterator
function iter(self)
   return ipairs(self.array)
end

--- Create a clone.
-- @param self instance 
-- @return a clone of the binary heap.
function clone(self)
   nt = class.rawnew(class.of(self))
   nt.array = table_utils.shallowcopy(self.array)
   nt.map = table_utils.shallowcopy(self.map)
   return nt
end

--- Insert an item into the binary heap. This is a O(log(N)) operation.
-- @param self instance 
-- @param item item to be stored in binary heap
function insert(self,item)
   local array, map = self.array, self.map
   local count = # array + 1
   local b
   local i = count
   while i > 1 do
      j = toint(i / 2)
      b = array[j]
      if not ( item < b ) then break end
      array[i], map[b] = b, i
      i = j
   end
   array[i],map[item] = item, i
end

--- Dequeue the minimum item from the binary heap. 
-- This is a O(log(N)) operation.
-- @param self instance 
-- @return the smallest item in the binary heap
function dequeuemin (self)
   local array, map = self.array, self.map
   local count = # array
   if count == 0 then return nil end
   local item, last = array[1], array[count]
   local i = 1
   local b, j
   while 2 * i < count do
      j = 2 * i
      if j + 1 < count and array[j + 1] < array[j] then
	 j = j + 1
      end
      b = array[j]
      if last < b then break end
      array[i], map[b] = b, i
      i = j
   end
   array[i], map[last] = last, i
   map[item] = nil
   table_remove(array)
   return item
end

--- Peek at the minimum item in the binary heap in O(1).
-- @param self instance 
-- @return top item in container and its key
function peekmin(self)
   return self.array[1]
end

--- Sift item up in O(log(N)). Call this function whenever the key
-- of an item has been decreased. 
-- @param self instance 
-- @param item an item in the binary heap
function siftup(self,item)
   local array,map = self.array, self.map
   local count = #array
   local i = map[item]
   assert(i ~= nil, "item not found!")
   local b,j 
   while i > 1 do
      j = toint(i / 2)
      b = array[j]
      if not ( item < b ) then break end
      array[i], map[b] = b, i
      i = j
   end
   array[i],map[item] = item, i
end

--- Sift item down in O(log(N)). Call this function whenever the key
-- of an item has been increased. 
-- @param self instance 
-- @param item an item in the binary heap
function siftdown(self,item)
   local array,map = self.array, self.map
   local count = #array
   local i = map[item]
   assert(i ~= nil, "item not found!")
   local b, j
   while 2 * i < count do
     j = 2 * i
      if j + 1 < count and array[j + 1] < array[j] then
	 j = j + 1
      end
      b = array[j]
      if item < b then break end
      array[i], map[b] = b, i
      i = j
   end
   array[i], map[item] = item, i
end

--- Fill the binary heap with items from the list.
-- @param self instance 
-- @param item_list a table of items to add to the binary heap
function fill(self, item_list)
   self:purge()
   for _,item in ipairs(item_list) do self:enqueue(item) end
end

--- Check whether item is contained within the binary heap.
-- @param self instance  
-- @param item the item to look for in the container
-- @return <i>true</i> or <i>false</i> depending on whether item is contained
function contains(self,item)
   return self.map[item] ~= nil
end

--- Find item within the container and return a reference if found.
-- @param self instance
-- @param item the item to look for in the container
-- @return if the item is found, the key of the item otherwise <i>nil</i>
function find(self,item) 
   if self.map[item] ~= nil then return item else return nil end
end

--- Merge with another binary heap in O(M*log(N+M))
-- @param self instance
-- @param other another binary heap
function merge(self,other)
   for i,v in ipairs(other.array) do self:enqueue(v) end
end


class.fuse(_M)

-------------------------------------------------------------------------------
