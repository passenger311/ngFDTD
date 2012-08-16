local FILE = {
------------------------------------------------------------------------------
module      = "neolib.collection.FibonacciHeap",
version     = "0.9",
date        = "7/31/2008",
author      = "j.hamm",
license     = "x11", 
lua_ver     = "5.1"
------------------------------------------------------------------------------
}

local class = require "neolib.oop.class"
local table_utils = require "neolib.util.table"

local _G, assert, string, table, math, select, pairs, ipairs, tostring, 
require, print
   =  _G, assert, string, table, math, select, pairs, ipairs, tostring, 
require, print

--- FibonacciHeap is an implementation of a Fibonacci Heap minimum priority 
-- queue. The asymptotic amortised cost its operations is lower than 
-- the ones provided by BinaryHeap. In addition the FibonacciHeap supports
-- an O(1) merge operation. However, it is more memory intensive and 
-- the maximum time of a single pop() and  changekey() operation can exceed
-- the amortised up to O(N). This implementation is an experimental adaption
-- of a Python code by Alistair Rendell.
module("neolib.collection.FibonacciHeap")

----------------------------------------------------------------------------
-- private methods
----------------------------------------------------------------------------

local function _refresh(item)
   item.degree = 0
   item.parent = nil
   item.child = nil
   item.left = item
   item.right = item
   item.mark = false
end

local function _add_list(y, x)
   -- add list y to x
   if y == nil or x == nil then return end
   local z = y
   while z.right ~= y do
      z.parent = x.parent
      z = z.right
   end
   z.parent = x.parent
   y.left = x.left
   x.left.right = y
   z.right = x
   x.left = z
end

local function _consolidate(H)
   local function _max_degree(n)
      local lg = 0
      while math.floor(n/2) > 0 do
	 lg = lg + 1
	 n = math.floor(n/2)
      end
      return lg
   end
   local function _link(y, x)
      y.left.right = y.right
      y.right.left = y.left
      y.parent = x
      if x.child ~= nil then
	 x.child.left.right = y
	 y.left = x.child.left
	 y.right = x.child
	 x.child.left = y
      else
	 x.child = y
	 y.left = y
	 y.right = y
      end
      x.degree = x.degree + 1
      y.mark = false
   end
   local max_degree = _max_degree(H.num)
   local A, root_list = {}, {}
   local x = H.min
   local d,y,next_x
   x.left.right = nil
   while x ~= nil do
      next_x = x.right
      x.left = x
      x.right = x
      table.insert(root_list,x)
      x = next_x
   end
   for _,x in ipairs(root_list) do
      d = x.degree
      while A[d] ~= nil do
	 y = A[d]
	 if y < x then x,y = y,x end
	 _link(y, x)
	 A[d] = nil
	 d = d + 1
      end
      A[d] = x
   end
   H.min = nil
   for _,x in pairs(A) do
      if x ~= nil then
	 x.left = x
	 x.right = x
	 x.parent = nil
	 if H.min == nil then
	    H.min = x
	 else
	    _add_list(x, H.min)
	    if x < H.min then H.min = x end
	 end
      end
   end
end

local function _cut(H, x, y)
   -- remove x from the child list of y, decrementing y.degree.
   x.left.right = x.right
   x.right.left = x.left
   y.degree = y.degree - 1
   y.child = x.right
   if x == x.right then y.child = nil end
   -- add x to the root list of H
   x.parent = nil
   x.mark = false
   x.left = H.min.left
   x.right = H.min
   x.left.right = x
   x.right.left = x
   --_add_list(x, H.min)
end

local function _cascading_cut(H, y)
   z = y.parent
   if z ~= nil then
      if y.mark == false then
	 y.mark = true
      else
	 _cut(H, y, z)
	 _cascading_cut(H, z)
      end
   end
end

----------------------------------------------------------------------------
-- FibonacciHeap class
----------------------------------------------------------------------------

class.def(_M, 
	  require "neolib.collection.IGenericPriorityQueue" )

function __init__(self,...)
   self:clear()
   for i = 1, select('#',...) do self:push(select(i,...)) end
end

function clear(self)
   self.num = 0
   self.min = nil
end

function count(self) 
   return self.num
end

function isempty(self)
   return self.num == 0
end


-- push item on queue in O(1)
function push(self,x)
   _refresh(x)
   if self.min == nil then
      self.min = x
   else
      local w = self.min.left
      local y = self.min
      x.left = w
      x.right = y
      w.right = x
      y.left = x
      if x < self.min then self.min = x end
   end
   self.num = self.num + 1
   return x
end

-- peek at top item in O(1)
function peek(self) 
   return self.min
end

-- pop top item in armotized O(log(N))
function pop(self)
   local x = self.min
   if x ~= nil then
      if x.child ~= nil then _add_list(x.child, x) end
      x.left.right = x.right
      x.right.left = x.left
      if x == x.right then
	 self.min = nil
      else
	 self.min = x.right
	 _consolidate(self)
      end
      self.num = self.num - 1
      _refresh(x)
   end
   return x
end

-- pop top item in armotized O(1)
function decreasekey(self, x)
   y = x.parent
   if y ~= nil and x < y then
      _cut(self, x, y)
      _cascading_cut(self, y)
   end
   if x < self.min then self.min = x end
end

-- merge two heaps in O(1)
function merge(self, other)
   if other.min == nil then
      return
   elseif self.min == nil then
      self.min = other.min
      self.num = other.num
   else
      _add_list(other.min, self.min)
      if self.min > other.min then
	 self.min = other.min
      end
      self.num = self.num + other.num
   end
end

-- fill
function fill(self, item_list)
   self:clear()
   for _,v in ipairs(item_list) do self:push(v) end
end

class.fuse(_M)

------------------------------------------------------------------------------
