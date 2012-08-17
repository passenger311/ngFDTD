--[[---------------------------------------------------------------------------
module      : xlib.collection.ListSet
version     : 0.9 
date        : 8/5/2008
author      : j.hamm
license     : x11 
lua_ver     : 5.1
---------------------------------------------------------------------------]]--
      
local class = require "xlib.oop.class"
local List = require "xlib.collection.List"

local pairs, ipairs, require, assert =  pairs, ipairs, require, assert

--- <p><b>Class:</b>  a ListSet is a double ended queue of set items. Adding
-- an item into the queue which already exists will not alter the state of the
--  queue. A <i>find</i> operation will return an unambiguous result. 
-- ListSets differ from DequeSets in that they use a double linked list
-- for implementation which makes random item insertion and removal an
-- O(1) operation.</p>
--
-- <p><b>Implements:</b>
-- <a href=xlib.collection.List.html>List</a>,
-- <a href=xlib.collection.IGenericSet.html>IGenericSet</a>
-- </p>
module("xlib.collection.ListSet")

-------------------------------------------------------------------------------

class.def( _M, 
	   require "xlib.collection.List",
	   require "xlib.collection.IGenericSet"  )

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
   self.map = {}
   self.head[NEXT] = self.tail
   self.tail[PREV] = self.head
   self.counter = 0
end

--- Return the count of a specific item.
-- @param self reference
-- @param item item to count
function countof(self,item)
   if self.map[item] then return 1 else return 0 end
end

--- Create a clone of the list.
-- @param self instance 
-- @return a clone of the instance.
function clone(self) 
   local nt = List.clone(self)
   nt.map = {}
   for k,v in pairs(self.map) do nt.map[k] = v end 
   return nt
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
   self.map[item] = nil
   return item
end

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
   self.map[item] = con
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
   self.map[item] = nil
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
   self.map[item] = con
   return con
end

--- Find an item in the list and return its position. This is an O(1) 
-- operation.
-- @param self instance
-- @return if found the items position, otherwise <i>nil</i>
function find(self,item)
   return self.map[item]
end

--- Check whether list contains the specified item. This is an O(1)
-- operation.
-- @param self instance
-- @param item
-- @return <i>true</i> if item found, otherwise <i>false</i>
function contains(self,item)
   return self.map[item] ~= nil
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
   self.map[item] = con
   return con
end

--- Remove the item at the given position. This is an O(1) operation.
-- @param self instance
-- @param pos the position
function remove(self,pos) 
   pos[PREV][NEXT] = pos[NEXT]
   pos[NEXT][PREV] = pos[PREV]
   self.counter = self.counter - 1
   self.map[pos] = nil
   pos = nil
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

class.fuse(_M)

-------------------------------------------------------------------------------
