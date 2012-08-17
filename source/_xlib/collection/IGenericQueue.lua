--[[---------------------------------------------------------------------------
$module      : xlib.collection.IGenericQueue
$version     : 0.9 
$date        : 8/5/2008
$author      : j.hamm
$license     : x11 
$lua_ver     : 5.1
---------------------------------------------------------------------------]]--
      
local class = require "xlib.oop.class"

local require = require

--- <p><b>Interface:</b> interface definition for a queue type container.
-- <p>
--
-- <p><b>Implements:</b> 
-- <a href=xlib.collection.IGenericContainer.html>IGenericContainer</a>,
-- <a href=xlib.collection.IEnumerable.html>IEnumerable</a>
-- </p>
module("xlib.collection.IGenericQueue")

-------------------------------------------------------------------------------

class.interface( _M, 
		 require "xlib.collection.IGenericContainer",
		 require "xlib.collection.IEnumerable" )

-------------------------------------------------------------------------------

--- Enqueue an item into the left end of the queue.
-- @class function
-- @name <i>enqueue</i>
-- @param self instance
-- @param item item to be stored in queue
enqueue = class.abstractmethod(self,item)

--- Dequeue the right-most item from the queue.
-- @class function
-- @name <i>dequeue</i>
-- @param self instance
-- @return right-most item in queue
dequeue = class.abstractmethod(self)

--- Peek at the right-most item.
-- @class function
-- @name <i>peek</i>
-- @param self instance
-- @return top item in queue
peek = class.abstractmethod(self)

--- Fill queue with items. The right-most item in the table is the right-most
-- item in the queue, i.e. the first item enqueued. 
-- @class function
-- @name <i>fill</i>
-- @param self instance
-- @param item_list a table of items
fill = class.abstractmethod(self,item)


-------------------------------------------------------------------------------
