--[[---------------------------------------------------------------------------
$module      : scape.collection.IGenericQueueOrStack
$version     : 0.9 
$date        : 8/5/2008
$author      : j.hamm
$license     : x11 
$lua_ver     : 5.1
---------------------------------------------------------------------------]]--
      
local class = require "scape.oop.class"

local require = require

--- <p><b>Interface:</b> interface definition of a container which represents
-- either a queue or a stack.
-- <p>
--
-- <p><b>Implements:</b> 
-- <a href=scape.collection.IGenericContainer.html>IGenericContainer</a>,
-- <a href=scape.collection.IEnumerable.html>IEnumerable</a>
-- </p>
module("scape.collection.IGenericQueueOrStack")

-------------------------------------------------------------------------------

class.interface( _M, 
		 require "scape.collection.IGenericContainer",
		 require "scape.collection.IEnumerable" )

-------------------------------------------------------------------------------

--- Push an item onto the queue or stack.
-- @class function
-- @name <i>push</i>
-- @param self class instance
-- @param item item to be stored in container
push = class.abstractmethod(self,item)

--- Pop an item from the queue or stack.
-- @class function
-- @name <i>pop</i>
-- @param self class instance
-- @return right-most item in container
pop = class.abstractmethod(self)

--- Peek at right-most item.
-- @class function
-- @name <i>peek</i>
-- @param self class instance
-- @return right-most item in container
peek = class.abstractmethod(self)

--- Fill set with items.
-- @class function
-- @name <i>fill</i>
-- @param self instance of a set
-- @param item_list a table of items
fill = class.abstractmethod(self,item)


-------------------------------------------------------------------------------
