--[[---------------------------------------------------------------------------
$module      : xlib.collection.ISearchTree
$version     : 0.9 
$date        : 8/5/2008
$author      : j.hamm
$license     : x11 
$lua_ver     : 5.1
---------------------------------------------------------------------------]]--
      
local class = require "xlib.oop.class"

local require = require

--- <p><b>Interface:</b> interface for a search tree.<p>
--
-- <p><b>Implements:</b> 
-- <a href=xlib.collection.IGenericTree.html>IGenericTree</a>,
-- <a href=xlib.collection.ISearchable.html>ISearchable</a>
-- </p>
module("xlib.collection.ISearchTree")

---------------------------------------------------------------------------

class.interface( _M, 
		 require "xlib.collection.IGenericTree",
		 require "xlib.collection.ISearchable" )


insert = class.abstractmethod(self,item)
remove = class.abstractmethod(self,item)
findmin = class.abstractmethod(self)
findmax = class.abstractmethod(self)
balance = class.abstractmethod(self)


----------------------------------------------------------------------------
