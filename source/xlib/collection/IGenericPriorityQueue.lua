--[[---------------------------------------------------------------------------
$module      : neolib.collection.IGenericPriorityQueue
$version     : 0.9 
$date        : 8/5/2008
$author      : j.hamm
$license     : x11 
$lua_ver     : 5.1
---------------------------------------------------------------------------]]--
      
local class = require "neolib.oop.class"
local require = require

--- <p><b>Interface:</b> 
-- a generic priority queue is a queue where each items are extracted 
-- according to their priority. The <i>pop()</i> function will always extract
-- the item in the queue which is smallest (according to __lt).<p>
--
-- <p><b>Implements:</b> 
-- <a href=neolib.collection.IGenericContainer.html>IGenericContainer</a>,
-- <a href=neolib.collection.ISearchable.html>ISearchable</a>
-- </p>
module("neolib.collection.IGenericPriorityQueue")

-------------------------------------------------------------------------------

class.interface( _M, 
		 require "neolib.collection.IGenericContainer",
		 require "neolib.collection.ISearchable" )

-------------------------------------------------------------------------------

--- Insert an item into the priority queue.
-- @class function
-- @name <i>insert</i>
-- @param self instance
-- @param item item to be stored in queue
insert = class.abstractmethod(self,item)

--- Dequeue the minimum item from the priority queue.
-- @class function
-- @name <i>dequeuemin</i>
-- @param self instance
-- @return right-most item in queue
dequeuemin = class.abstractmethod(self)

--- Peek at the minimum item in the priority queue.
-- @class function
-- @name <i>peekmin</i>
-- @param self instance
-- @return the smallest item in queue
peekmin = class.abstractmethod(self)

--- Fill priority queue with items. 
-- @class function
-- @name <i>fill</i>
-- @param self instance
-- @param item_list a table of items
fill = class.abstractmethod(self,item)

--- Adjust the position of an item in the queue if the item has been
-- decreased. Decreasing the item followed by a siftup is equivalent to a
-- <i>decreasekey</i> operation. 
-- @class function
-- @name <i>siftup</i>
-- @param self instance
-- @param item an item in the queue
siftup = class.abstractmethod(self,item) 

--- Adjust the position of an item in the queue if the item has been
-- increased. Increasing the item followed by a siftdown is equivalent to a
-- <i>increasekey</i> operation. 
-- @class function
-- @name <i>increasekey</i>
-- @param self instance
-- @param item an item in the queue
siftdown = class.abstractmethod(self,item) 

--- Merge the priority queue with another priority queue.
-- @class function
-- @name <i>merge</i>
-- @param self instance
-- @param other another instance of a priority queue
merge = class.abstractmethod(self,other)


-------------------------------------------------------------------------------
