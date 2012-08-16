-------------------------------------------------------------------------------
-- neolib.collection.IGenericSet
--
-- @copyright $date$
-- @author    $author$
-- @release   $release$
-------------------------------------------------------------------------------
      
local module= require "neolib.module"
local class = require "neolib.oop.class"

-------------------------------------------------------------------------------

local table_insert, table_concat = table.insert, table.concat
local require, tostring = require, tostring

-------------------------------------------------------------------------------
--- <p><b>Interface:</b> a generic set-like container which stores items in
-- no particular order.
-- </p>
--
-- <p><b>Implements:</b> 
-- <a href=neolib.collection.IGenericContainer.html>IGenericContainer</a>,
-- <a href=neolib.collection.IEnumerable.html>IEnumerable</a>,
-- <a href=neolib.collection.ISearchable.html>ISearchable</a>,
-- <a href=neolib.collection.IPrintable.html>IPrintable</a>
-- </p>
module("neolib.collection.IGenericSet")
-------------------------------------------------------------------------------

class.interface( _M, 
		 require "neolib.collection.IGenericContainer",
		 require "neolib.collection.IEnumerable", 
		 require "neolib.collection.ISearchable",
		 require "neolib.generic.IPrintable" 
	      )

--- Insert an item into the set.
-- @class function
-- @name <i>insert</i>
-- @param self instance 
-- @param item the item to put into the set
insert   = class.abstractmethod(self,item)

--- Fill set with items.
-- @class function
-- @name <i>fill</i>
-- @param self instance 
-- @param item_list a table of items
fill   = class.abstractmethod(self,item)

--- Return the count of a specific item.
-- @class function
-- @name countof
-- @param self reference
-- @param item item to count
countof = class.abstractmethod(self,item) 

--- Remove an item from the set.
-- @class function
-- @name <i>remove</i>
-- @param self instance 
-- @param item the item to remove from the set
remove   = class.abstractmethod(self,item) 

--- Merge the other set into the set.
-- @class function
-- @name <i>merge</i>
-- @param self instance 
-- @param other another set which is merged into <i>self</i>
merge    = class.abstractmethod(self,other)

--- Subtract the other set items from the set.
-- @class function
-- @name <i>subtract</i>
-- @param self instance
-- @param other another set whose items are removed from <i>self</i>
subtract = class.abstractmethod(self,other)

--- Intersect the items from other set with items in the set.
-- @class function
-- @name <i>intersect</i>
-- @param self instance
-- @param other another set whose items are intersected with <i>self</i>
intersect = class.abstractmethod(self,other)

--- Add two sets and return a set.
-- @param self instance
-- @param other another set-like container
-- @return a new set which contains the items of self plus the items of other
function __add(a,b)
   local c = a:clone()
   c:merge(b)
   return c
end

--- Subtract two sets and return a set.
-- @param self instance
-- @param other another set-like container
-- @return a new which contains the items of self minus the items of other
function __sub(a,b)
   local c = a:clone()
   c:subtract(b)
   return c
end

--- Intersect two sets and return a set.
-- @param self instance
-- @param other another set-like container
-- @return a new which contains the items of self minus the items of other
function __mul(a,b)
   local c = a:clone()
   c:intersect(b)
   return c
end

--- Build a printable string from set.
-- @param self instance
-- @return a string 
function __tostring(self)
   local tab = {}
   for _,v in self:iter() do table_insert(tab,tostring(v)) end
   return "["..table_concat(tab,",").."]"
end

----------------------------------------------------------------------------
