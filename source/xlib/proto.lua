local _H = {
-------------------------------------------------------------------------------
PROJECT   = "xlib",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "14/08/2012 16:01",
COPYRIGHT = "GPL V2",
FILE      = "xlib.proto",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local object = L.object

-------------------------------------------------------------------------------

local _getmetatable, _setmetatable, _pairs, _rawget, _type = 
   getmetatable, setmetatable, pairs, rawget, type

-------------------------------------------------------------------------------
---<p><b>Prototype</b>: super light-weight prototyping. </p>
-- The metatable of a prototype always points to its parent. Delegation 
-- (rather than copying) is used to search ancestors for data and function 
-- members. Instantation is therefore generally fast but dispatch slows down 
-- for deep hierarchies. Fusion allows to flatten the hierarchy of ancestors.
-- First-order instances are empty tables with a metatable pointing to the
-- ancestor prototype. Tagging adds an identifier to the prototype which 
-- enables isa-checks.
--
module( "xlib.proto" )
-------------------------------------------------------------------------------

root = _M -- module itself is the root class

--- Root prototype. All prototypes are offsprings of <i>root</i>.
-- @class table
-- @name root
root = _M
root[root] = true
root.__index = root


--- Delegate to self.new(...) constructor.
-- @param self prototype 
-- @param ... arguments
-- @return offspring as created by self.new(...)
function __call(self, ...)
   return self.new(...)
end

--- Adopt offspring by parent prototype. 
-- @param self parent prototype
-- @param offspring offspring table
-- @return new offspring
function _adopt(self, offspring)
   offspring.__index = offspring
   return _setmetatable(offspring, self)
end

--- Return the abstract method. Abstract methods throw an error when invoked 
-- and are not allowed to remain exposed after object fusion.
-- @param ... dummy arguments
-- @return abstract method
_abstract = object.abstractmethod

--- Return dummy method. A dummy methods does nothing and is used when
-- a default do-nothing operation is required.
-- @param ... dummy arguments
-- @return dummy method
_dummy = object.dummymethod

--- Get parent of prototype.
-- @class function
-- @name parent
-- @param self prototype
-- @return parent prototype
_parent = _getmetatable

local function _pfuse(parent, offspring)
   for k,v in _pairs(parent) do 
      if not offspring[k] then offspring[k] = v end
   end
   local meta = _getmetatable(parent)
   if parent ~= root then _fuse(meta,offspring) end
end

--- Fuse all ancestor tables into prototype. This increases performance of
-- function dispatch at cost of dynamicity.
-- @param self prototype
-- @return self
function _fuse(self)
   local meta = _getmetatable(self)
   _setmetatable(self,nil)
   _pfuse( meta, self )
   self.__index = self
   return _setmetatable(self,root)
end

--- Scrub prototype removing module related variables.
-- @param self prototype
-- @return self
function _scrub(self)
   self._M = nil
   self._PACKAGE = nil
   self._NAME = nil
   return self
end

--- Tag prototype object by adding an id. This enables <i>isa</i> checks for
-- this type.
-- @param self prototype
-- @return self
function _tag(self)
   self[self] = true
   return self
end

--- Check whether prototype is an offspring of other prototype. Requires parent
-- prototype to be tagged using <i>tag()</i> function.
-- @param self prototype
-- @param other other prototype
-- @return <tt>true</tt> or <tt>nil</tt>
function _isa(self, other)
   if _type(self) ~= 'table' then return nil end
   return self[other]
end

--- Return type of prototype.
-- @param self prototype
-- @return metatable of self
function _type(self)
   return _getmetatable(self)
end

--- Seal protoype by using tag, fuse and scrub (in this order).
-- @param self prototype
-- @return self
function _seal(self)
   return _scrub(_fuse(_tag(self)))
end

 
-------------------------------------------------------------------------------
