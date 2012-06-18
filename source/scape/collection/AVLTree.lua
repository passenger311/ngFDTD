--[[---------------------------------------------------------------------------
module      : scape.collection.AVLTree
version     : 0.9 
date        : 8/5/2008
author      : j.hamm
license     : x11 
lua_ver     : 5.1
---------------------------------------------------------------------------]]--
      
local class = require "scape.oop.class"
local table_utils = require "scape.util.table"
local toint = math.floor
local math_max = math.max
local table_insert = table.insert

local pairs, require, assert, type =  pairs, require, assert, type

--- <p><b>Class:</b> the AVL self balancing binary search tree.
-- <p>
--
-- <p><b>Implements:</b> 
-- <a href=scape.collection.BinarySearchTree.html>BinarySearchTree</a>
-- </p>
module("scape.collection.AVLTree")

-------------------------------------------------------------------------------

local AVLTree = class.def( _M, 
			   require "scape.collection.BinarySearchTree" )

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
   self.height = -1
end

function adjustheight(self)
   if self:isempty() then self.height = -1
   else self.height = math_max(self[LEFT].height, self[RIGHT].height) + 1
   end
end

function balancefactor(self)
   if # self == 0 then return 0
   else return self[LEFT].height - self[RIGHT].height
   end
end

function LLrotate(self)
   assert(not self:isempty(), "internal error!")
   local tmp = self[RIGHT]
   self[RIGHT] = self[LEFT]
   self[LEFT] = self[RIGHT][LEFT]
   self[RIGHT][LEFT] = self[RIGHT][RIGHT]
   self[RIGHT][RIGHT] = tmp
   tmp = self.item
   self.item = self[RIGHT].item
   self[RIGHT].item = tmp
   self[RIGHT]:adjustheight()
   self:adjustheight()
end

function LRrotate(self)
   assert(not self:isempty(), "internal error!")
   self[LEFT]:RRrotate()
   self:LLrotate()
end

function RRrotate(self)
   assert(not self:isempty(), "internal error!")
   local tmp = self[LEFT]
   self[LEFT] = self[RIGHT]
   self[RIGHT] = self[LEFT][RIGHT]
   self[LEFT][RIGHT] = self[LEFT][LEFT]
   self[LEFT][LEFT] = tmp
   tmp = self.item
   self.item = self[LEFT].item
   self[LEFT].item = tmp
   self[LEFT]:adjustheight()
   self:adjustheight()
end

function RLrotation(self)
   assert(not self:isempty(), "internal error!")
   self[RIGHT]:LLrotate()
   self:RRrotate()
end

function balance(self)
   self:adjustheight()
   if self:balancefactor() > 1 then
      if self[LEFT]:balancefactor() > 0 then
	 self:LLrotate()
      else
	 self:LRrotate()
      end
   elseif self:balancefactor() < -1 then
      if self[RIGHT]:balancefactor() < 0 then
	 self:RRrotate()
      else
	 self:RLrotate()
      end
   end
end

class.fuse(_M)

-------------------------------------------------------------------------------
