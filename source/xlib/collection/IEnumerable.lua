--[[---------------------------------------------------------------------------
$module      : xlib.collection.IEnumerable
$version     : 0.9 
$date        : 8/5/2008
$author      : j.hamm
$license     : x11 
$lua_ver     : 5.1
---------------------------------------------------------------------------]]--

      
local class = require "xlib.oop.class"

--- <p><b>Interface:</b> 
-- mixin for a container which supports enumeration. 
-- <p>
--
module("xlib.collection.IEnumerable")

-------------------------------------------------------------------------------

class.interface(_M)

-------------------------------------------------------------------------------

--- Return a iterator which allows to loop over all items inside the container. 
-- @class function
-- @name <i>iter<i>
-- @param self object instance
-- @return <i>pairs</i> type iterator which loops over key, item pairs
iter = class.abstractmethod(self)  --> iterator

--- Use the iterator to call the visitor function for each element. The default
-- implementation is to use <i>iter</i> to loop over the items.
-- @param self object instance
-- @param visitor visitor function which takes the enumerated item as argument
function foreach(self,visitor)
   for _,item in self:iter() do visitor(item) end
end

-------------------------------------------------------------------------------
