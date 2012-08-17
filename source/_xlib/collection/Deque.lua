--[[---------------------------------------------------------------------------
module      : xlib.collection.Deque
version     : 0.9 
date        : 8/5/2008
author      : j.hamm
license     : x11 
lua_ver     : 5.1
---------------------------------------------------------------------------]]--
     
local class = require "xlib.oop.class"
local table_insert = table.insert
local table_remove = table.remove

local pairs, ipairs, require, assert =  pairs, ipairs, require, assert

--- <p><b>Class:</b> a double ended queue with push and pop operations that 
-- apply to both the left and the right end of the queue. A Deque differs
-- from a List that it uses an array based implementation which is both more
-- memory efficient and faster on pop and push. Item search is O(N).
-- </p>
--
-- <p><b>Implements:</b>
-- <a href=xlib.collection.IGenericDoubleEndedQueue.html>
--                           IGenericDoubleEndedQueue</a>,
-- <a href=xlib.collection.ISearchable.html>ISearchable</a>, 
-- <a href=xlib.collection.ISortable.html>ISortable</a>, 
-- <a href=xlib.generic.IConvertible.html>IConvertible</a>, 
-- <a href=xlib.generic.ICloneable.html>ICloneable</a> 
-- </p>
module("xlib.collection.Deque")

-------------------------------------------------------------------------------

class.def( _M, 
	   require "xlib.collection.IGenericDoubleEndedQueue",
	   require "xlib.collection.ISearchable",
	   require "xlib.collection.ISortable",
	   require "xlib.generic.IConvertible",
	   require "xlib.generic.ICloneable" )

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
end

--- Fill the deque with items from the table.
-- @param self instance 
-- @param item_list a table of items to add
function fill(self,item_list)
   self.array = {}
   self.first = 1
   self.last = # item_list
   for _,v in ipairs(item_list) do table_insert(self.array, v) end
end

--- Create a clone of the deque.
-- @param self instance 
-- @return a clone of the instance.
function clone(self) 
   local nt = class.rawnew(class.of(self))
   nt.array = {}
   for i,v in pairs(self.array) do nt.array[i] = v end
   nt.first = self.first
   nt.last = self.last
   return nt
end

--- Check whether deque is empty or not.
-- @param self instance 
-- @return <i>true</i> if deque is empty, otherwise <i>false</i>
function isempty(self)
   return self.first > self.last
end

--- Return the number of items in the deque.
-- @param self instance 
-- @return number of items in the deque
function count(self)
   return self.last - self.first + 1
end

--
local function _getnext(self,i)
   i = i + 1
   if i > self.last then return end
   return i,self.array[i]
end

--- Return an iterator which allows to loop over all items inside the deque
-- in forward order.
-- @param self instance 
-- @return <i>pairs</i> type iterator
function iter(self)
   return _getnext, self, self.first - 1
end

--
local function _getprev(self,i)
   i = i - 1
   if i < self.first then return end
   return i,self.array[i]
end

--- Return an iterator which allows to loop over all items inside the deque
-- in reverse order.
-- @param self instance 
-- @return <i>pairs</i> type iterator
function riter(self)
   return _getprev, self, self.last + 1 
end

--- Pop the right-most item from the deque. 
-- @param self instance 
-- @return item the right-most item
function pop(self)
   local last =  self.last
   if last < self.first then return end
   local item = self.array[last]
   self.array[last] = nil
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
   self.last =  self.last + 1
   self.array[self.last] = item
   return self.last
end

--- Peek at right-most item.
-- @param self instance
-- @return right-most item
function peek(self)
   local last =  self.last
   if last <  self.first then return end
   return self.array[last]
end

--- Pop the left-most item from the deque. 
-- @param self instance 
-- @return item the left-most item
function popleft(self)
   local first =  self.first
   if first >  self.last then return end
   local item = self.array[first]
   self.array[first] = nil
   self.first = self.first + 1
   return item
end

--- Push an item into left end of the deque.
-- @param self instance 
-- @param item item to be stored in deque
-- @return position of inserted item
function pushleft(self,item)
   self.first = self.first - 1
   self.array[self.first] = item
   return self.first
end

--- Alias for <i>pushleft</i>. Push an item into left end of the deque.
-- @class function
-- @name dequeue
-- @param self instance 
-- @param item item to be stored in deque
enqueue = pushleft

--- Peek at left-most item.
-- @param self instance
-- @return left-most item
function peekleft(self)
   local first =  self.first
   if first > self.last then return end
   return self.array[first]
end

--- Find an item in the deque and return its position. This is an O(N)
-- operation.
-- @param self instance
-- @param item
-- @return if found the items position, otherwise <i>nil</i>
function find(self,item)
   for i,v in self:iter() do if v == item then return i end end
   return
end

--- Check whether deque contains the specified item. This is an O(N)
-- operation.
-- @param self instance
-- @param item
-- @return <i>true</i> if item found, otherwise <i>false</i>
function contains(self,item)
   for i,v in pairs(self.array) do if v == item then return true end end
   return
end

--- Insert an item at the given position.
-- @param self instance
-- @param pos the position
-- @param item the item to be inserted
-- @return position of inserted item
function insert(self,pos,item)
   assert(pos >= self.first and pos <= self.last+1,"index out of range!")
   table_insert(self.array,pos,item)
   self.last = self.last + 1
   return pos
end

--- Remove the item at the given position.
-- @param self instance
-- @param pos the position
function remove(self,pos)
   assert(pos >= self.first and pos <= self.last+1,"index out of range!")
   table_remove(self.array,pos)
   self.last = self.last - 1
end

--- Create a compact table which contains all information of instance.
-- @class function
-- @name totable
-- @param self instance
-- @return a table which contains all information of the instance
function totable(self)
   local tab = {}
   for i,v in self:iter() do tab[i-self.first+1] = v end
   return tab
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
   for i,v in ipairs(tab) do self.array[i] = v end
end


class.fuse(_M)

-------------------------------------------------------------------------------

