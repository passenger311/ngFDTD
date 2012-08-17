--[[---------------------------------------------------------------------------
$module      : xlib.collection.IReverseEnumerable
$version     : 0.9 
$date        : 8/5/2008
$author      : j.hamm
$license     : x11 
$lua_ver     : 5.1
---------------------------------------------------------------------------]]--
      
local class = require "xlib.oop.class"

local _G, require = _G, require

--- <p><b>Interface:</b> 
-- mixin for a container which supports forward and backward enumeration. Note,
-- that this implies an underlying order of item.
-- <p>
--
-- <p><b>Implements:</b> 
-- <a href=xlib.collection.IEnumerable.html>IEnumerable</a>
-- </p>
--
module("xlib.collection.IReverseEnumerable")

-------------------------------------------------------------------------------

class.interface( _M,
		 require "xlib.collection.IEnumerable" )

-------------------------------------------------------------------------------


--- Return a reverse iterator which allows to loop backwards over all items
--  inside the container. 
-- @class function
-- @name <i>riter</i>
-- @param self object instance
-- @return <i>pairs</i> type iterator which loops over key, item pairs
riter = class.abstractmethod(self)


--- Use the backward iterator to call the visitor function for each element.
--  The default implementation is to use <i>riter</i> to loop over the items.
-- @param self object instance
-- @param visitor visitor function which takes the enumerated item as argument
function rforeach(self,visitor)
   for _,item in self:iter() do visitor(item) end
end


-------------------------------------------------------------------------------
