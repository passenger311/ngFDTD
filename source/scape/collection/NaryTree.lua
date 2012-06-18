--[[---------------------------------------------------------------------------
module      : scape.collection.NaryTree
version     : 0.9 
date        : 8/5/2008
author      : j.hamm
license     : x11 
lua_ver     : 5.1
---------------------------------------------------------------------------]]--
      
local class = require "scape.oop.class"
local table_utils = require "scape.util.table"
local GeneralTree = require "scape.collection.GeneralTree"
local toint = math.floor
local math_min = math.min
local table_insert = table.insert


local pairs, require, assert, type, select =  
   pairs, require, assert, type, select

--- <p><b>Class:</b> a table based implementation of a n-ary tree
-- directly derived from GeneralTree.
-- <p>
--
-- <p><b>Implements:</b> 
-- <a href=scape.collection.GeneralTree.html>GeneralTree</a>
-- </p>
--
module("scape.collection.NaryTree")

-------------------------------------------------------------------------------

local NaryTree = class.def(_M, GeneralTree )

-------------------------------------------------------------------------------

--- Initializer.
-- @param self tree
-- @param nary the maximum number of branches per node
-- @param tree_table a table used to <i>fill()</i> the tree
function __init__(self, nary, item, ...)
   self.n = nary
   self.item = item
   local n = math_min(nary, select('#',...))
   for i=1,n do self[i] = select(i,...) end
end

--- Fill the tree from a tree table. The table is a nested ordered array where 
-- each sub-array or non-table value represents a node. The table is inserted
-- into the tree with little modification, but that any non-table array value 
-- is interpreted as the item of a leaf node which will be automatically boxed.
-- @param self tree node
-- @param tree_table initializer table
function fill(self, tree_table)
   local n = self.n
   local Class = class.of(self)
   self:purge()
   function _fix(tab)
      class.as(tab,Class)
      tab.n = n
      for i = 1,n do -- maximum of n branches!
	 local v = tab[i]
	 if type(v) == 'table' then 
	    _fix(v) 
	 else
	    tab[i] = class.as({ item = v }, Class)
	 end
      end
   end
   if type(tree_table) == 'table' then 
      _fix(tree_table) 
      for k,v in pairs(tree_table) do self[k] = v end
   else
      self.item = tree_table
   end
end

--- Attach a sub-tree to tree node.
-- @param self tree node
-- @param subtree the subtree to attach to node
function attach(self,subtree) 
   local n = self.n
   assert(#self < n,"branch limit exceeded!")
   assert( subtree.n == n and 
	   class.instanceof(subtree,NaryTree),"not a nary tree!")
   table_insert(self,subtree)
end

class.fuse(_M)

-------------------------------------------------------------------------------
