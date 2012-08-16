--[[---------------------------------------------------------------------------
module      : neolib.collection.BinarySearchTree
version     : 0.9 
date        : 8/5/2008
author      : j.hamm
license     : x11 
lua_ver     : 5.1
---------------------------------------------------------------------------]]--
      
local class = require "neolib.oop.class"
local table_utils = require "neolib.util.table"
local toint = math.floor
local table_insert = table.insert

local pairs, require, assert, type =  pairs, require, assert, type

--- <p><b>Class:</b> a binary search tree.
-- <p>
--
-- <p><b>Implements:</b> 
-- <a href=neolib.collection.BinaryTree.html>BinaryTree</a>,
-- <a href=neolib.collection.ISearchTree.html>ISearchTree</a>
-- </p>
module("neolib.collection.BinarySearchTree")

-------------------------------------------------------------------------------

class.def( _M, 
	   require "neolib.collection.BinaryTree",
	   require "neolib.collection.ISearchTree"
	)

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

function balance = class.dummymethod(self)

function find(self,key)
   if self:isempty() then
      return nil
   end
   local item = self.item
   if key < item then
      return self[LEFT]:find(key)
   elseif item < key then
      return self[RIGHT]:find(key)
   else
      return item
   end
end

function contains(self,key)
   if self:isempty() then
      return false
   end
   local item = self.item
   if key < item then
      return self[LEFT]:find(key)
   elseif item < key then
      return self[RIGHT]:find(key)
   else
      return true
   end
end

function findmin(self)
   if not self[LEFT] then
      return self.item
   else
      return self[LEFT]:findmin()
   end
end

function findmax(self)
   if not self[RIGHT] then
      return self.item
   else
      return self[RIGHT]:findmax()
   end
end

function insert(self,item)
   if self:isempty() then
      self[LEFT] = BinarySearchTree()
      self[RIGHT] = BinarySearchTree()
      self.item = item
   else
      local key = self.item
      if item < key then
	 self[LEFT]:insert(item)
      elseif key < item then
	 self[RIGHT]:insert(item)
      else
	 error("duplicate key!")
      end
   end
   self:balance()
end

function remove(self,key)
    if self:isempty() then
       error "key not found!"
    end
    local item = self.item
    if key < item then
       self[LEFT]:remove(key)
    elseif item < key then
       self[RIGHT]:remove(key)
    else
       if not self.left:is_empty() then
	    local max = self.left:get_max()
	    self.key = max
	    self.left:withdraw(max)
	elseif not self.right:is_empty() then
	    local min = self.right:get_min()
	    self.key = min
	    self.right:withdraw(min)
	else
	    self:detachKey()
	end
    end
    self:balance()
 end

class.fuse(_M)

-------------------------------------------------------------------------------
