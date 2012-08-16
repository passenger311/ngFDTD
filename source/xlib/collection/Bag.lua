--[[---------------------------------------------------------------------------
$module      : xlib.collection.Bag
$version     : 0.9 
$date        : 8/5/2008
$author      : j.hamm
$license     : x11 
$lua_ver     : 5.1
---------------------------------------------------------------------------]]--
      
local class = require "xlib.oop.class"
local math_min = math.min

local pairs, ipairs, tostring, require, next = 
   pairs, ipairs, tostring, require, next

--- <p><b>Class:</b> an unordered set of items which can hold multiples of
--  each item. 
-- </p>
--
-- <p><b>Interface:</b>
-- <a href=xlib.collection.IGenericSet.html>IGenericSet</a>,
-- <a href=xlib.generic.ICloneable.html>ICloneable</a>, 
-- <a href=xlib.generic.IConvertible.html>IConvertible</a>, 
-- <a href=xlib.generic.IPrintable.html>IPrintable</a> 
-- </p>
module("xlib.collection.Bag")

-------------------------------------------------------------------------------

class.def( _M, 
	   require "xlib.collection.IGenericSet",
	   require "xlib.generic.ICloneable",
	   require "xlib.generic.IConvertible",
	   require "xlib.generic.IPrintable" )

-------------------------------------------------------------------------------

--- Initializer.
-- @param self instance 
-- @param item_list <i>optional</i> table of items to enqueue
function __init__(self,item_list)
   if item_list then self:fill(item_list) else self:purge() end
end

--- Purge all items from the bag.
-- @param self instance 
function purge(self)
   self.map = {}
end

--- Create a clone of the bag.
-- @param self instance 
-- @return a clone of the instance.
function clone(self)
   local nt = class.rawnew(class.of(self))
   nt.map = {}
   for k,v in pairs(self.map) do nt.map[k] = v end
   return nt
end

--- Fill the bag with items from the table.
-- @param self instance 
-- @param item_list a table of items to add
function fill(self,item_list) 
   local cnt
   self.map = {}
   for i,v in ipairs(item_list) do
      cnt = self.map[v]
      if cnt then self.map[v] = cnt+1 else self.map[v] = 1 end
   end
end

--- Check whether bag is empty or not.
-- @param self instance 
-- @return <i>true</i> if bag is empty, otherwise <i>false</i>
function isempty(self)
   return count(self) == 0 
end

--- Return the number of items in the bag.
-- @param self instance 
-- @return number of items in the bag
function count(self)
   local count = 0
   for _,v in pairs(self.map) do count = count + v end
   return count
end

--- Return the count of a specific item.
-- @param self reference
-- @param item item to count
function countof(self,item)
   return self.map[item] or 0
end

--- Return an iterator which allows to loop over all items inside the bag.
-- @param self instance 
-- @return <i>pairs</i> type iterator
function iter(self) 
   local count = 1
   return function(self, k)
	     count = count - 1
	     if count == 0 then
		k,count = next(self.map,k)
	     end
	     return k,k
	  end, self, nil
end

--- Insert an item into bag.
-- @param self instance
-- @param item item to be put into bag
function insert(self,item)
   local cnt = self.map[item]
   cnt = cnt or 0
   self.map[item] = cnt + 1
end

--- Remove an item from bag.
-- @param self instance
-- @param item item to be removed
function remove(self,item)
   local cnt = self.map[item]
   assert(cnt,"item not in bag!")
   cnt = cnt - 1 
   if cnt <= 0 then
      self.map[item] = nil
   else
      self.map[item] = cnt
   end
end

--- Merge another set-like instance into the bag.
-- @param self instance
-- @param other other set-like instance
function merge(self,other)
   local cnt
   for k,_ in pairs(other.map) do
      cnt = ( self.map[k] or 0 ) + other:countof(k)
      self.map[k] = cnt
   end
end

--- Subtract another set-like instance from the bag.
-- @param self instance
-- @param other other set-like instance
function subtract(self,other)
   local cnt
   for k,_ in pairs(other.map) do 
      cnt = ( self.map[k] or 0 ) - other:countof(k)
      if cnt > 0 then self.map[k] = cnt else self.map[k] = nil end 
   end
end

--- Intersect another set-like instance with the bag.
-- @param self instance
-- @param other other set-like instance
function intersect(self,other)
   for k,v in pairs(self.map) do
      local w = other:countof(k)
      if w > 0 then 
	 self.map[k] = math_min(v,w)
      else
	 self.map[k] = nil
      end
   end
end

--- Check whether for an item inside the bag.
-- @param self instance 
-- @param item the item to look for in the container
-- @return <i>true</i> if item is found, otherwise <i>false</i>
function contains(self,item)
   return self.map[item] ~= nil
end

--- Find an item within the bag.
-- @param self instance
-- @param item the item to look for in the bag
-- @return the item itself if found, otherwise <i>nil</i>
function find(self,item)
   if self.map[item] then return item else return end
end

-- Create a compact table which contains all information of the bag.
-- @param self instance
-- @return a table which contains all information of the bag
function totable(self)
   local tab = {}
   for k,v in pairs(self.map) do tab[k] = v end
   return tab
end

--- Initialize from table which has been created with <i>fromtable()</i>.
-- @param self instance
-- @param table the table from which the bag is to be initialised
function fromtable(self,tab)
   self.map = {}
   for k,v in pairs(tab) do self.map[k] = v end
end


class.fuse(_M)

-------------------------------------------------------------------------------
