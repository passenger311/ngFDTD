local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.2",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2",
FILE      = "scape.struct.list",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local proto = L.proto
local table = L.table

-------------------------------------------------------------------------------

local _pairs, _ipairs, _next, _tostring = pairs, ipairs, next, tostring
local _table_insert, _table_concat, _table_remove = 
   table.insert, table.concat, table.remove
local _type = type

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> a list. </p>
-- The list holds an ordered sequence of items. 
-- </p>
module("scape.struct.list")
-------------------------------------------------------------------------------

this = proto.clone( proto.root, _M )

--- Create list and initialize with table.
-- @param tab table of items
-- @return new list 
function new(tab) 
   return proto.clone(this, tab or {} )
end

--- Purge all items.
-- @param self list 
-- @return self
function purge(self)
   for i=#self,1 do self[i] = nil end
   return self
end

--- Create a clone of self.
-- @param self list 
-- @param object new object [{}]
-- @return clone of list.
function clone(self, object)
   object = object or {}
   for i=1, #self do
      object[i] = self[i]
   end
   return proto.clone(this, object)
end

--- Check whether self is empty.
-- @param self list 
-- @return <tt>true</tt> if empty; <tt>false</tt> otherwise
function isempty(self)
   return #self == 0
end

--- Number of items.
-- @param self list 
-- @return number of items
function size(self)
   return #self
end

--- Return number of times item occurs in list.
-- @param self reference
-- @param item item
-- @return count of item
function count(self,item)
   local c = 0
   for i=1, #self do
      if self[i] == item then c = c + 1 end
   end
   return c
end

--- Iterate over items.
-- @param self list 
-- @return iterator
items = _ipairs

--- Add item(s) to end of list.
-- @param self list
-- @param item item, table of items, or list
-- @return self 
function add(self,item)
   if _type(item) == 'table' then
      for i=1, #item do 
	 _table_insert(self, item[i]) 
      end
   else
      _table_insert(self,item)
   end
   return self
end

--- Insert item(s) at position or beginning of list.
-- @param self list
-- @param item item, table of items, or list
-- @return self 
function put(self, pos, item)
   if item == nil then 
      item, pos = pos, 1
   end
   if pos < 1 or pos > #self then return end
   if _type(item) == 'table' then
      for i= #item,1,-1 do 
	 _table_insert(self, pos, item[i]) 
      end
   else
      _table_insert(self, pos, item)
   end
   return self
end


--- Delete item at end or given position from list.
-- @param self list
-- @param pos position (default: 1)
-- @return self 
function del(self,pos)
   _table_remove(self, pos)
   return self
end

--- Find first occurence of item in list.
-- @param self list
-- @param item item
-- @return index or item iterator
function find(self,item)
   for i=1,#self do 
      if self[i] == item then return i end
   end
end

--- Remove item(s) from list.
-- @param self list
-- @param item item, table of items, or list
-- @return self
function remove(self,item)
   if _type(item) == 'table' then
      for i=1, #item do
	 self:remove(item[i])
      end
   else
      for i=1, #self do
	 if self[i] == item then
	    _table_remove(self, i)
	    return self
	 end
      end
   end
   return self
end


--- Check whether list contains item(s).
-- @param self list 
-- @param item item, table of items or list
-- @return <i>true</i> if self contains item(s), otherwise <i>false</i>
function contains(self,item)
   if _type(item) == 'table' then
      for i=1, #item do
	 if not self:contains(item[i]) then return false end
      end
   else
      if not self:find(item) then return false end
   end
   return true
end

-- Save content into table.
-- @param self list
-- @return a item table
function totable(self)
   local tab = {}
   for i=1, #self do tab[i] = self[i] end
   return tab
end

--- Load from table.
-- @param self list
-- @param tab item table
function fromtable(self,tab)
   self:purge()
   for i=1, #tab do self[i] = tab[i] end
   return self
end

--- Create union of two lists.
-- @param a list
-- @param b other list
-- @return union of items
function __add(a,b)
   return a:clone():add(b)
end

--- Check whether list contains item(s).
-- @class function
-- @name __mod
-- @param self list 
-- @param other item, table of items or list
-- @return <i>true</i> if self contains item(s), otherwise <i>false</i>
-- @see contains
__mod = contains

--- Index function.
-- @class function
-- @name __index
-- @param self list 
-- @param pos position
-- @return item or <i>nil</i>
__index = nil

--- Build a printable string from list.
-- @param self list
-- @return string 
function __tostring(self)
   local tab = {}
   return "{".._table_concat(self,",").."}"
end

proto.seal(this)

-------------------------------------------------------------------------------
