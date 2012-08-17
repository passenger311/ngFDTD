--[[---------------------------------------------------------------------------
module      : xlib.collection.BinaryTree
version     : 0.9 
date        : 8/5/2008
author      : j.hamm
license     : x11 
lua_ver     : 5.1
---------------------------------------------------------------------------]]--
      
local class = require "xlib.oop.class"
local table_utils = require "xlib.util.table"
local GeneralTree = require "xlib.collection.GeneralTree"
local toint = math.floor
local table_insert = table.insert

local pairs, require, assert, type =  pairs, require, assert, type

--- <p><b>Class:</b> a table based implementation of a binary tree
-- directly derived from GeneralTree.
-- <p>
--
-- <p><b>Implements:</b> 
-- <a href=xlib.collection.GeneralTree.html>GeneralTree</a>
-- </p>
module("xlib.collection.BinaryTree")

-------------------------------------------------------------------------------

local BinaryTree = class.def(_M, GeneralTree )

-------------------------------------------------------------------------------

local LEFT, RIGHT = 1,2

--- Initializer.
-- @param self tree
-- @param item the item to insert into tree node
-- @param left the left sub-tree
-- @param right the right sub-tree
function __init__(self, item, left, right)
   self.item = item
   self[LEFT] = left
   self[RIGHT] = right
end

--- Degree of the tree node.
-- @class function
-- @name degree
-- @param self tree node
-- @return the degree of the tree node
function degree(self)
   local cnt = 0
   if self[LEFT] then cnt = cnt + 1 end
   if self[RIGHT] then cnt = cnt + 1 end
   return cnt
end

--- Return the left sub-tree
-- @param self tree node
-- @return left sub-tree
function left(self) return self[1] end

--- Return the right sub-tree
-- @param self tree node
-- @return right sub-tree
function right(self) return self[2] end

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
      for i = 1,2 do -- only take 2 branches!
	 local v = tab[i]
	 if type(v) == 'table' then _fix(v) 
	 else tab[i] = class.as({ item = v }, Class)
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
   assert(#self < 2,"branch limit exceeded!")
   assert(class.instanceof(subtree,BinaryTree),"not a binary tree!")
   table_insert(self,subtree)
end

--- Traverses the nodes of the tree using a recursive depth-first.
-- @param self tree node
-- @param previsitor visitor called when node is entered 
-- @param invisitor visitor called on exit of the first branch and before 
-- entering the second branch
-- @param postvisitor visitor called when node is exited
function traverse(self,previsitor,invisitor,postvisitor)
   if not # self == 0 then
      local left, right = self[LEFT], self[RIGHT] 
      if previsitor then previsitor(self) end
      if left then left:traverse(previsitor,invisitor,postvisitor) end
      if invisitor then invisitor(self) end
      if right then right:traverse(previsitor,invisitor,postvisitor) end
      if postvisitor then postvisitor(self) end
   end
end

class.fuse(_M)

-------------------------------------------------------------------------------
