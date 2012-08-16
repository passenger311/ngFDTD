--[[---------------------------------------------------------------------------
module      : xlib.collection.GeneralTree
version     : 0.9 
date        : 8/5/2008
author      : j.hamm
license     : x11 
lua_ver     : 5.1
---------------------------------------------------------------------------]]--
      
local class = require "xlib.oop.class"
local table_utils = require "xlib.util.table"
local IGenericTree = require "xlib.collection.IGenericTree"
local toint = math.floor
local table_insert, table_remove, table_getn = 
   table.insert, table.remove, table.getn

local pairs, ipairs, require, assert, type, select
   =  pairs, ipairs, require, assert, type, select

--- <p><b>Class:</b> a slick table based implementation of a general tree.
-- <p>
--
-- <p><b>Implements:</b> 
-- <a href=xlib.collection.IGenericTree.html>IGenericTree</a>
-- </p>
--
module("xlib.collection.GeneralTree")

-------------------------------------------------------------------------------

class.def( _M, IGenericTree )

-------------------------------------------------------------------------------


--- Initializer.
-- @param self tree
-- @param item item to be stored in tree node
-- @param ... a list of sub-trees
function __init__(self, item, ...)
   self.item = item
   for i=1,select('#',...) do self[i] = select(i,...) end
end

--- Purge tree node by removing content and all branches. The result is an 
-- empty tree node.
-- @param self tree node
function purge(self)
   for k,v in pairs(self) do self[k] = nil end
end

--- Degree of the tree node.
-- @class function
-- @name degree
-- @param self tree node
-- @return the degree of the tree node
degree = table_getn

--- Check whether tree is empty or not. A tree is considered empty if it 
-- is a leaf-node and has no item.
-- @param self tree node
-- @return <i>true</i> or <i>false</i> depending on whether tree is 
-- empty or not
function isempty(self)
   return self:degree() == 0 and self.item == nil 
end

--- Fill the tree from a tree table. The table is a nested ordered array where 
-- each sub-array or non-table value represents a node. The table is inserted
-- into the tree with little modification, but that any non-table array value 
-- is interpreted as the item of a leaf node which will be automatically boxed.
-- @param self tree node
-- @param tree_table initializer table
function fill(self, tree_table)
   local Class = class.of(self)
   self:purge()
   function _fix(tab)
      class.as(tab,Class)
      for i,v in ipairs(tab) do 
	 if type(v) == 'table' then _fix(v) else
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

--- Attach a sub-tree as right-most branch to the tree node.
-- @class function
-- @name attach
-- @param self tree node
-- @param subtree the subtree to attach to node
attach = table_insert

--- Detach a sub-tree from tree node.
-- @param self tree node
-- @param subtree the sub-tree to detach from tree node
function detach(self,subtree)
   for i,v in ipairs(self) do 
      if v == subtree then table_remove(self,i) return end 
   end
end

--- Return iterator over sub-trees. Note, that the branches of the tree must
-- be populated from left to right without gaps.
-- @class function
-- @name successors
-- @param self tree node
-- @return an iterator which loops over all sub-trees
successors = ipairs

class.fuse(_M)

-------------------------------------------------------------------------------
