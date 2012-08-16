--[[---------------------------------------------------------------------------
$module      : neolib.collection.ISortable
$version     : 0.9 
$date        : 8/5/2008
$author      : j.hamm
$license     : x11 
$lua_ver     : 5.1
---------------------------------------------------------------------------]]--
      
local class = require "neolib.oop.class"

local IConvertible = require "neolib.generic.IConvertible"

local require, table, assert = require, table, assert

--- <p><b>Interface:</b> 
-- mixin for containers which allow their content to be sorted.<p>
--
module("neolib.collection.ISortable")

---------------------------------------------------------------------------

class.interface( _M )

--- Sort items in container with the smallest item being the left-most. The
-- default implementation is to use the <i>IConvertible</i> interface and
-- <i>table.sort</i>.
-- @class function
-- @name sort
-- @param self instance 
function sort(self)
   assert(class.instanceof(self,IConvertible),"requires IConvertible!")
   local tab = self:totable()
   table.sort(tab)
   self:fromtable(tab)
end
   
--- Sort items in container with the smallest item being the right-most. The
-- default implementation is to use the <i>IConvertible</i> interface and
-- <i>table.sort</i>.
-- @class function
-- @name rsort
-- @param self instance 
function rsort(self)
   assert(class.instanceof(self,IConvertible),"requires IConvertible!")
   local function cmp(a,b) return b < a end
   local tab = self:totable()
   table.sort(tab, cmp)
   self:fromtable(tab)
end


----------------------------------------------------------------------------
