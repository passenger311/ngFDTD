local _H = {
-------------------------------------------------------------------------------
PROJECT   = "xlib",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "14/08/2012 16:01",
COPYRIGHT = "GPL V2",
FILE      = "xlib.class",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local object = L.object

-------------------------------------------------------------------------------
     
local _rawget, _getmetatable, _setmetatable, _error, _pairs, _print = 
   rawget, getmetatable, setmetatable, error, pairs, print

-------------------------------------------------------------------------------
---<p><b>Module</b>: heavy-duty class model. </p>
-- Class model support multiple inheritance, dynamic dispatch, interfaces 
-- and optional the fusion with ancestor objects to flatten the class hierachy 
-- into a single base. Class creation is complex but instantiation is
-- generally fast.
--
module( "xlib.class" )
-------------------------------------------------------------------------------

--- Return the abstract method. Abstract methods throw an error when invoked 
-- and are not allowed to remain exposed after object fusion.
-- @param ... dummy arguments
-- @return abstract method
abstractmethod = object.abstractmethod

--- Return the dummy method. A dummy methods does nothing and is used when
-- a default do-nothing operation is required.
-- @param ... dummy arguments
-- @return dummy method
dummymethod = object.dummymethod

--- Return an iterator to loop over super classes of class.
-- @class function
-- @name supers
-- @param class class table
-- @return <i>ipairs()</i> type iterator
supers = object.ancestors

--- Check whether first argument is an instance of second argument.
-- @class function
-- @name instanceof
-- @param instance instance table
-- @param class supposed super-class of class associated with instance
-- @return <i>true</i> or <i>false</i>
instanceof = object.implements

--- Check whether first argument is a sub-class of second argument.
-- @class function
-- @name subclassof
-- @param class class table
-- @param other class supposed to be the super-class
-- @return <i>true</i> or <i>false</i>
subclassof = object.implements

--- Get class table associated with instance table. 
-- @class function
-- @name of
-- @param instance instance table
-- @return class table
of = object.parent

--- Check whether the given object is a class.
-- @class function
-- @name isclass
-- @param object object table
-- @return <i>true</i> if object is a class, <i>false</i> otherwise
isclass = object.isobject

--- Return attributes. Return an iterator to loop over all attributes 
-- associated with given class table.
-- @class function
-- @name attribs
-- @param class class table
-- @return <i>pairs()</i> type iterator.
attribs = _pairs

--- Create a raw instance of given class. This function can also be used
-- to change the class table associated with a given instance. <i>rawnew()</i> 
-- does not invoke the initializer function.
-- @class function
-- @name delegate
-- @param self class table
-- @param tab storage for new instance [{}]
-- @return instance table
rawnew = object.delegate

--- Check whether the given table is an instance table.
-- @param self instance table
-- @return <i>true</i> if object is an instance, <i>false</i> otherwise
function isinstance(self) 
   return of(self) ~= nil 
end

--- Define an interface.
-- @param tab storage for new class table [{}]
-- @param ... list of super classes
-- @return class interface table
function interface(tab, ...)
   if isclass(tab) then
      return object.create({}, object.c3bases( tab, ...), object.selfdispatch)
   else
      return object.create(tab or {}, object.c3bases(...), object.selfdispatch)
   end
end

local function new_proxy(self,...)
   local instance = _setmetatable({},_getmetatable(self)) 
   local init = _rawget(self,"__init__")
   if init then init(instance,...) end
   return instance
end

--- Define a new class. 
-- @param tab storage for new class table [{}]
-- @param ... list of super-classes
-- @return class table
function def(tab, ...)
   local class
   if isclass(tab) then
      class = object.create({}, object.c3bases( tab, ...))
   else
      class = object.create(tab or {}, object.c3bases(...))
   end
   _getmetatable(class).__call = new_proxy
   return class
end

local function new_self(self,...)
   local instance = _setmetatable({},self)
   local init = _rawget(self,"__init__")
   if init then init(instance,...) end
   return instance
end

--- Fuse class objects by injecting super-class attributes.
-- @param tab class table
-- @return class table
function fuse(class) 
   object.fuse( class, object.c3bases( class ) )
   for k,v in _pairs(class) do
      if v == m_abstract then 
	 _error("abstract method "..k.." not implemented!")
      end
   end
   _getmetatable(class).__call = new_self
   return class
end

--- Create a clone of a class.
-- @param self class
-- @return clone of class
function clone(self)
   local clone = object.merge(object.delegate(self))
   clone.__init__ = self.__init__
   return clone
end


-------------------------------------------------------------------------------
