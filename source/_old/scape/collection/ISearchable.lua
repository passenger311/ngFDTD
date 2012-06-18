--[[---------------------------------------------------------------------------
$module      : scape.collection.ISearchable
$version     : 0.9 
$date        : 8/5/2008
$author      : j.hamm
$license     : x11 
$lua_ver     : 5.1
---------------------------------------------------------------------------]]--
      
local class = require "scape.oop.class"

local require = require

--- <p><b>Interface:</b> 
-- mixin that defines an interface for searching items inside of containers.
-- This interface is particularily useful in combination with insert and 
-- remove functions or other container manipulation which require a 
-- reference to the item's location.<p>
--
module("scape.collection.ISearchable")

---------------------------------------------------------------------------

class.interface( _M )

--- Check whether an item is inside the container. The default
-- implementation is to return <i>self:find(item) ~= nil</i>.
-- @class function
-- @name contains
-- @param self instance 
-- @param item the item to look for in the container
-- @return <i>true</i> if item is found, otherwise <i>false</i>
function contains(self,item) 
   return self:find(item) ~= nil
end

--- Find an item within the container.
-- @class function
-- @name <i>find</i>
-- @param self instance
-- @param item the item to look for in the container
-- @return a reference to the item if found, otherwise <i>nil</i>
find = class.abstractmethod(self,item)




----------------------------------------------------------------------------
