local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.proto",
VERSION   = "0.1",
DATE      = "17/08/2012 16:29",
COPYRIGHT = "(C) 2012",
-------------------------------------------------------------------------------
}

local xlib = require( "xlib" )
local module = xlib.module
local object = xlib.object

-------------------------------------------------------------------------------

local _getmetatable, _setmetatable, _pairs, _rawget, _rawset, _type, _error = 
   getmetatable, setmetatable, pairs, rawget, rawset, type, error

-------------------------------------------------------------------------------
---<p><b>Prototype</b>: super light-weight prototyping. </p>
-- The metatable of a prototype always points to its parent. Delegation 
-- (rather than copying) is used to search ancestors for data and function 
-- members. Instantation is therefore generally fast but dispatch slows down 
-- for deep hierarchies. Fusion allows to flatten the hierarchy of ancestors.
-- Tagging adds an identifier to the prototype enabling isa-checks.
--
module( "xlib.proto" )
-------------------------------------------------------------------------------

local this = _M

--- Root prototype. All prototypes are children of <i>root</i>.
-- @class table
-- @name root
root = this
root[root] = true
root.__index = root

--- Adopt child by parent prototype. 
-- @param this parent prototype
-- @param child child table
-- @return new child
function adopt(this, child)
   child.__index = child
   return _setmetatable(child, this)
end

--- Get parent of prototype.
-- @class function
-- @name parent
-- @param self prototype
-- @return parent prototype
parent = _getmetatable

local function _pfuse(child, parent)
   for k,v in _pairs(parent) do 
      if not _rawget(child,k) then _rawset(child,k,v) end
   end
   if parent ~= root then _pfuse(child, _getmetatable(parent)) end
   return child
end

--- Fuse all ancestor tables into prototype. May increases performance of
-- function dispatch at cost of dynamic behaviour.
-- @param this prototype
-- @return this
function fuse(this)
   return _pfuse( this, this:parent() ) 
end

--- Seal prototype removing module related variables and setting id for isa
-- checks.
-- @param this prototype
-- @return this
function seal(this)
   this._M = nil
   this._PACKAGE = nil
   this._NAME = nil
   this[this] = true
   return this
end

--- Check whether prototype is a child of other prototype. Requires parent
-- prototype to be tagged using <i>tag()</i> function.
-- @param this prototype
-- @param other other prototype
-- @return <tt>true</tt> or <tt>nil</tt>
function isa(this, other)
   if _type(this) ~= 'table' then return false end
   return this[other] or false
end


local _virtfun = function() _error("virtual function invoked!") end

--- Returns a function that throws an error when invoked. 
-- Used for defining interfaces.
-- @return function
function virtfun()
   return _virtfun
end


this:seal()
 
-------------------------------------------------------------------------------
