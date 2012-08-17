--[[---------------------------------------------------------------------------
$module      : scape.collection.IGenericStack
$version     : 0.9 
$date        : 8/5/2008
$author      : j.hamm
$license     : x11 
$lua_ver     : 5.1
---------------------------------------------------------------------------]]--
      
local class = require "scape.oop.class"

local require = require

--- <p><b>Interface:</b> interface definition for a stack-type container.
-- <p>
--
-- <p><b>Implements:</b> 
-- <a href=scape.collection.IGenericContainer.html>IGenericContainer</a>,
-- <a href=scape.collection.IEnumerable.html>IEnumerable</a>
-- </p>
--
module("scape.collection.IGenericStack")

-------------------------------------------------------------------------------

class.interface( _M, 
		 require "scape.collection.IGenericContainer",
		 require "scape.collection.IEnumerable" )

-------------------------------------------------------------------------------

--- Push an item onto the right end of the stack.
-- @class function
-- @name <i>push</i>
-- @param self instance
-- @param item item to be stored in stack
push = class.abstractmethod(self,item)

--- Pop right-most (top) item from the stack.
-- @class function
-- @name <i>pop</i>
-- @param self instance
-- @return right-most item on stack
pop = class.abstractmethod(self)

--- Peek at right-most (top) item.
-- @class function
-- @name <i>peek</i>
-- @param self instance
-- @return right-most item on stack
peek = class.abstractmethod(self)

--- Fill stack with items. The right-most item in the table is the right-most
-- item on the stack, i.e. the last item pushed onto stack.
-- @class function
-- @name <i>fill</i>
-- @param self instance
-- @param item_list a table of items
fill = class.abstractmethod(self,item)


-------------------------------------------------------------------------------
