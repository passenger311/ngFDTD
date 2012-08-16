--[[---------------------------------------------------------------------------
$module      : neolib.collection.Bits
$version     : 0.9 
$date        : 8/5/2008
$author      : j.hamm
$license     : x11 
$lua_ver     : 5.1
---------------------------------------------------------------------------]]--
      
local class = require "neolib.oop.class"
local table_insert = table.insert

local pairs, ipairs, tostring, require, next = 
   pairs, ipairs, tostring, require, next

if not _LMAKE_ then
   local bit = require "neolib.embeds.bit"
end

--- <p><b>Class:</b> a bit-set stores integers as bits.
-- </p>
--
-- <p><b>Interface:</b>
-- <a href=neolib.collection.IGenericSet.html>IGenericSet</a>,
-- <a href=neolib.generic.ICloneable.html>ICloneable</a>, 
-- <a href=neolib.generic.IConvertible.html>IConvertible</a>, 
-- <a href=neolib.serialization.IPrintable.html>IPrintable</a>
-- </p>
module("neolib.collection.Bits")

-------------------------------------------------------------------------------

class.def( _M, 
	   require "neolib.collection.IGenericSet",
	   require "neolib.generic.IConvertible",
	   require "neolib.generic.ICloneable",
	   require "neolib.generic.IPrintable" )

-------------------------------------------------------------------------------


--- Initializer.
-- @param self instance 
-- @param item_list <i>optional</i> table of items to enqueue
function __init__(self,item_list)
   if item_list then self:fill(item_list) else self:purge() end
end

--- Purge all items from the set.
-- @param self instance 
function purge(self)
   self.map = {}
   self._count = 0
end

--- Create a clone of the set.
-- @param self instance 
-- @return a clone of the instance.
function clone(self)
   local nt = class.rawnew(class.of(self))
   nt.map = {}
   for k,v in pairs(self.map) do nt.map[k] = v end
   nt._count = self._count
   return nt
end

--- Fill the set with items from the table.
-- @param self instance 
-- @param item_list a table of items to add
function fill(self,item_list) 
   local cnt
   self.map = {}
   for i,v in ipairs(item_list) do self:insert(v) end
end

--- Check whether set is empty or not.
-- @param self instance 
-- @return <i>true</i> if set is empty, otherwise <i>false</i>
function isempty(self)
   return self._count == 0 
end

--- Return the number of items in the set.
-- @param self instance 
-- @return number of items in the set
function count(self)
   return self._count
end

--- Return the count of a specific item.
-- @param self reference
-- @param item item to count
function countof(self,item)
   if self:contains(item) then return 1 else return 0 end
end

--
local function _get_next(map, k)
   local k = next(map,k)
   return k,k
end
--- Return an iterator which allows to loop over all items inside the set.
-- @param self instance 
-- @return <i>pairs</i> type iterator
function iter(self) 
   return _get_next, self.map, nil
end

--- Insert an item into set.
-- @param self instance
-- @param item item to be put into set
function insert(self,item)
   if self.map[item] then return end
   self.map[item] = 1
end

--- Remove an item from set.
-- @param self instance
-- @param item item to be removed
function remove(self,item)
   local cnt = self.map[item]
   assert(cnt,"item not in set!")
   self.map[item] = nil
end

--- Merge another set-like instance into the set.
-- @param self instance
-- @param other other set-like instance
function merge(self,other)
   for k,_ in pairs(other.map) do
      if not self.map[k] then self.map[k] = 1 end
   end
end

--- Subtract another set-like instance from the set.
-- @param self instance
-- @param other other set-like instance
function subtract(self,other)
   for k,_ in pairs(other.map) do 
      if self.map[k] then self.map[k] = nil end
   end
end

--- Intersect another set-like instance with the set.
-- @param self instance
-- @param other other set-like instance
function intersect(self,other)
   for k,_ in pairs(self.map) do 
      if not other.map[k] then self.map[k] = nil end
   end
end

--- Check whether for an item inside the set.
-- @param self instance 
-- @param item the item to look for in the container
-- @return <i>true</i> if item is found, otherwise <i>false</i>
function contains(self,item)
   return self.map[item] ~= nil
end

--- Find an item within the set.
-- @param self instance
-- @param item the item to look for in the set
-- @return the item itself if found, otherwise <i>nil</i>
function find(self,item)
   if self.map[item] then return item else return end
end

-- Create a compact table which contains all information of the set.
-- @param self instance
-- @return a table which contains all information of the set
function totable(self)
   local tab = {}
   for k,_ in pairs(self.map) do table_insert(tab,k) end
   return tab
end

--- Initialize from table which has been created with <i>fromtable()</i>.
-- @param self instance
-- @param table the table from which the set is to be initialised
function fromtable(self,tab)
   self.map = {}
   for k,v in pairs(tab) do self.map[k] = 1 end
end

class.fuse(_M)

-------------------------------------------------------------------------------
