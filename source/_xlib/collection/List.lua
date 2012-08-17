--[[---------------------------------------------------------------------------
module      : xlib.collection.List
version     : 0.9 
date        : 8/5/2008
author      : j.hamm
license     : x11 
lua_ver     : 5.1
---------------------------------------------------------------------------]]--
      
local class = require "xlib.oop.class"

local pairs, ipairs, require, assert =  pairs, ipairs, require, assert

--- <p><b>Class:</b> a double ended queue with push and pop operations that 
-- apply to both the left and the right end of the queue. A List differs
-- from a Deque that it uses a linked-list implementation. Item search is O(N).
-- Item insertion and deletion is O(1).
-- </p>
--
-- <p><b>Implements:</b>
-- <a href=xlib.collection.IGenericDoubleEndedQueue.html>
--                           IGenericDoubleEndedQueue</a>,
-- <a href=xlib.collection.ISortable.html>ISortable</a>, 
-- <a href=xlib.generic.IConvertible.html>IConvertible</a>, 
-- <a href=xlib.generic.ICloneable.html>ICloneable</a>, 
-- <a href=xlib.serialization.ISerializable.html>ISerializable</a>
-- </p>
module("xlib.collection.List")

-------------------------------------------------------------------------------

class.def( _M, 
	   require "xlib.collection.IGenericDoubleEndedQueue",
	   require "xlib.collection.ISortable",
	   require "xlib.generic.ICloneable",
	   require "xlib.generic.IConvertible"
       )

-------------------------------------------------------------------------------

local NEXT, PREV, ITEM = 1, 2, 3

--- Initializer.
-- @param self instance 
-- @param item_list <i>optional</i> table of items to enqueue
function __init__(self,item_list)
   if item_list then self:fill(item_list) else self:purge() end
end


--- Purge all items from the list.
-- @param self instance 
function purge(self)
   self.tail = {}
   self.head = {}
   self.head[NEXT] = self.tail
   self.tail[PREV] = self.head
   self.counter = 0
end

--- Fill the list with items in the table.
-- @param self instance 
-- @param item_list a table of items to add
function fill(self,item_list)
   self:purge()
   for _,v in ipairs(item_list) do self:push(v) end
end

--- Create a clone of the list.
-- @param self instance 
-- @return a clone of the instance.
function clone(self) 
   local nt = class.rawnew(class.of(self))
   nt.head,nt.tail = {},{}
   local prev = nt.head
   local con
   for _,v in self:iter() do
      con = { [PREV]=prev, [ITEM]=v }
      prev[NEXT] = con
      prev = con
   end
   con[NEXT] = nt.tail
   nt.tail[PREV] = con
   nt.counter = self.counter
   return nt
end

--- Check whether list is empty or not.
-- @param self instance 
-- @return <i>true</i> if list is empty, otherwise <i>false</i>
function isempty(self) return self.counter == 0 end

--- Return the number of items in the list.
-- @param self instance 
-- @return number of items in the list
function count(self) return self.counter end

--
local function _getnext(self,cur)
   cur = cur[NEXT]
   if cur ~= self.tail then return cur,cur[ITEM] else return end
end

--- Return an iterator which allows to loop over all items inside the list
-- in forward order.
-- @param self instance 
-- @return <i>pairs</i> type iterator
function iter(self) 
   return _getnext, self, self.head
end

--
local function _getprev(self,cur)
   cur = cur[PREV]
   if cur ~= self.head then return cur,cur[ITEM] else return end
end

--- Return an iterator which allows to loop over all items inside the list
-- in reverse order.
-- @param self instance 
-- @return <i>pairs</i> type iterator
function riter(self) 
   return _getprev, self, self.tail
end

--- Pop the right-most item from the list. 
-- @param self instance 
-- @return item the right-most item
function pop(self)
   local last = self.tail[PREV]
   if last == self.head then return end
   local item = last[ITEM]
   self.tail[PREV] = last[PREV]
   last[PREV][NEXT] = self.tail
   last = nil
   self.counter = self.counter - 1
   return item
end

--- Alias for <i>pop</i>. Pop the right-most item from the list. 
-- @class function
-- @name enqueue
-- @param self instance 
-- @return item the right-most item
dequeue = pop

--- Push an item into right end of the list.
-- @param self instance 
-- @param item item to be stored in list
-- @return position of inserted item
function push(self,item)
   local last = self.tail[PREV]
   local con = { [NEXT]=self.tail, [PREV]=last, [ITEM]=item }
   self.tail[PREV] = con
   last[NEXT] = con
   self.counter = self.counter + 1
   return con
end

--- Peek at right-most item.
-- @param self instance
-- @return right-most item
function peek(self)
   local last =  self.tail[PREV]
   if last == self.head then return end
   return last[ITEM]
end

--- Pop the left-most item from the list. 
-- @param self instance 
-- @return item the left-most item
function popleft(self)
   local first =  self.head[NEXT]
   if first == self.tail then return end
   local item = first[ITEM]
   self.head[NEXT] = first[NEXT]
   first[NEXT][PREV] = self.head
   first = nil
   self.counter = self.counter - 1
   return item
end

--- Push an item into left end of the list.
-- @param self instance 
-- @param item item to be stored in list
-- @return position of inserted item
function pushleft(self,item)
   local first = self.head[NEXT]
   local con = { [NEXT]=first, [PREV]=self.head, [ITEM]=item }
   self.head[NEXT] = con
   first[PREV] = con
   self.counter = self.counter + 1
   return con
end

--- Alias for <i>pushleft</i>. Push an item into left end of the list.
-- @class function
-- @name dequeue
-- @param self instance 
-- @param item item to be stored in deque
enqueue = pushleft

--- Peek at left-most item.
-- @param self instance
-- @return left-most item
function peekleft(self)
   local first =  self.head[NEXT]
   if first == self.tail then return end
   return  first[ITEM]
end

--- Find an item in the list and return its position. This is an O(N)
-- operation.
-- @param self instance
-- @return if found the items position, otherwise <i>nil</i>
function find(self,item)
   for k,v in self:iter() do if item == v then return k end end
   return
end

--- Check whether list contains the specified item. This is an O(N)
-- operation.
-- @param self instance
-- @param item
-- @return <i>true</i> if item found, otherwise <i>false</i>
function contains(self,item)
   for k,v in self:iter() do if item == v then return true end end
   return
end

--- Insert an item at the given position. This is an O(1) operation.
-- @param self instance
-- @param pos the position
-- @param item the item to be inserted
-- @return position of inserted item
function insert(self,pos,item) 
   local con = { [NEXT]=pos, [PREV]=pos[PREV], [ITEM]=item }
   pos[PREV][NEXT] = con 
   pos[PREV] = con
   self.counter = self.counter + 1
   return con
end

--- Remove the item at the given position. This is an O(1) operation.
-- @param self instance
-- @param pos the position
function remove(self,pos) 
   pos[PREV][NEXT] = pos[NEXT]
   pos[NEXT][PREV] = pos[PREV]
   self.counter = self.counter - 1
   pos = nil
end

--- Create a compact table which contains all information of instance.
-- @class function
-- @name totable
-- @param self instance
-- @return a table which contains all information of the instance
function totable(self)
   local tab, i = {}, 1
   for _,v in self:iter() do
      tab[i] = v
      i = i + 1
   end
   return tab
end

--- Initialize from table which has been created with <i>fromtable()</i>.
-- @class function
-- @name fromtable
-- @param self instance
-- @param table the table from which the instance is to be initialised
function fromtable(self, tab)
   self:purge()
   for i,v in ipairs(tab) do self:push(v) end
end

--class.fuse(_M)

-------------------------------------------------------------------------------
