--[[---------------------------------------------------------------------------
$module      : neolib.collection.IGenericDoubleEndedQueue
$version     : 0.9 
$date        : 8/5/2008
$author      : j.hamm
$license     : x11 
$lua_ver     : 5.1
---------------------------------------------------------------------------]]--
      
local class = require "neolib.oop.class"

local require = require

--- <p><b>Interface:</b> a generic container which supports insertion and 
-- removal of items from both ends. 
-- </p>
--
-- <p><b>Implements:</b> 
-- <a href=neolib.collection.IGenericQueue.html>IGenericQueue</a>,
-- <a href=neolib.collection.IGenericStack.html>IGenericStack</a>,
-- <a href=neolib.collection.IReverseEnumerable.html>IReverseEnumerable</a>
-- </p>
module("neolib.collection.IGenericDoubleEndedQueue")

-------------------------------------------------------------------------------

class.interface( _M, 
		 require "neolib.collection.IGenericQueue",
		 require "neolib.collection.IGenericStack",
	         require "neolib.collection.IReverseEnumerable" )
 
-------------------------------------------------------------------------------

--- Push an item into the left end of the double ended queue.
-- @class function
-- @name <i>push</i>
-- @param self class instance
-- @param item item to be stored in the double ended queue
pushleft = class.abstractmethod(self,item)

--- Pop the left-most item from the double ended queue.
-- @class function
-- @name <i>pop</i>
-- @param self instance
-- @return left-most item in the double ended queue
popleft  = class.abstractmethod(self)

--- Peek at left-most item in the double ended queue.
-- @class function
-- @name <i>peek</i>
-- @param self instance
-- @return left-most item in the double ended queue
peekleft = class.abstractmethod(self)


-------------------------------------------------------------------------------
