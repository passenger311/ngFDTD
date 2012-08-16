--[[---------------------------------------------------------------------------
$module      : neolib.collection.IGenericContainer
$version     : 0.9 
$date        : 8/5/2008
$author      : j.hamm
$license     : x11 
$lua_ver     : 5.1
---------------------------------------------------------------------------]]--
      
local class = require "neolib.oop.class"

local require = require

--- <p><b>Interface:</b> characterizes a generic container which can hold a 
-- countable number of items.
-- <p>
--
module("neolib.collection.IGenericContainer")

-------------------------------------------------------------------------------

class.interface( _M )

-------------------------------------------------------------------------------

--- Purge all items from container, leaving it empty.
-- @class function
-- @name <i>purge</i>
-- @param self instance
purge = class.abstractmethod(self)

--- Check whether container is empty or not. The default implementation is 
-- to return <i>self:count() == 0</i>.
-- @class function
-- @name isempty
-- @param self instance
-- @return <i>true</i> or <i>false</i> depending on whether container is 
-- empty or not
function isempty(self) return self:count() == 0 end

--- Return the number of items in the container.
-- @class function
-- @name <i>count</i>
-- @param self instance
-- @return number of items in the container
count = class.abstractmethod(self)


-------------------------------------------------------------------------------
