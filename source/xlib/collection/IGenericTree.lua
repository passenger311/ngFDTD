local FILE = {
------------------------------------------------------------------------------
module      = "neolib.collection.IGenericTree",
version     = "0.9",
date        = "7/31/2008",
author      = "j.hamm",
license     = "x11", 
lua_ver     = "5.1"
------------------------------------------------------------------------------
}
      
local class = require "neolib.oop.class"

local _G, require, type, ipairs, math, table = 
   _G, require, type, ipairs, math, table

--- <p><b>Interface:</b> 
-- interface definition for generic tree structures.
-- <p>
--
-- <p><b>Implements:</b> 
-- <a href=neolib.collection.IGenericContainer.html>IGenericContainer</a>,
-- <a href=neolib.collection.IEnumerable.html>IEnumerable</a>,
-- <a href=neolib.collection.ISearchable.html>ISearchable</a>,
-- </p>
module("neolib.collection.IGenericTree")

---------------------------------------------------------------------------

class.interface( _M, 
		 require "neolib.collection.IGenericContainer",
		 require "neolib.collection.IEnumerable",
		 require "neolib.collection.ISearchable" )

---------------------------------------------------------------------------

--- Return the degree of the tree node, i.e. the number of subtrees.
-- @class function
-- @name <i>degree</i>
-- @param self tree node
-- @return degree of node
degree = class.abstractmethod(self) 

--- Check whether tree is empty or not. A tree is considered empty if it 
-- is a leaf-node and has no item.
-- @class function
-- @name <i>isempty</i>
-- @param self tree node
-- @return <i>true</i> or <i>false</i> depending on whether tree is 
-- empty or not
isempty = class.abstractmethod(self) 

--- Attach a sub-tree to the tree node.  
-- @class function
-- @name <i>attach</i>
-- @param self tree node
-- @param subtree sub-tree 
attach = class.abstractmethod(self,subtree)

--- Detach a sub-tree from the tree node.  
-- @class function
-- @name <i>detach</i>
-- @param self tree node
-- @param subtree sub-tree or item
detach = class.abstractmethod(self,subtree)

--- Fill the tree from a tree table. The table is a nested ordered array where 
-- each sub-array or non-table value represents a node. The table is inserted
-- into the tree with little modification, but that any non-table array value is
-- interpreted as the item of a leaf node which will be automatically boxed.
-- @class function
-- @name <i>fill</i>
-- @param self tree node
-- @param tree_table initializer table
fill  = class.abstractmethod(self, tree_table)

--- Return iterator over successor sub-trees.
-- @class function
-- @name <i>successors</i>
-- @param self tree node
-- @return an iterator which loops over all sub-trees
successors = class.abstractmethod(self)

--- Return the sub-tree associated with item
-- @param self tree node
-- @param item item of the branch
-- @return the tree node associated with item
function branchof(self,item) 
   for i,v in self:successors() do if v:item() == item then return v end end
   return nil
end

--- Check whether the tree node is a leaf node. The default implementation
-- returns <i> self:degree() == 0</i>.
-- @class function
-- @name isleaf
-- @param self tree node
-- @return <i>true</i> if node is a leaf node, <i>false</i>  otherwise.
function isleaf(self) return self:degree() == 0 end

--- Return the height of the tree.
-- @param self tree
-- @return height of the tree
function height(self) 
   local height = -1
   for i,v  in self:successors() do
      height = math.max(height, v:height())
   end
   return height + 1
 end

--- Return the number of nodes in the tree.
-- @param self tree node
-- @return height of the tree
function count(self)
   local result = 1
   for i,v  in self:successors() do
      result = result + v:count()
   end
   return result
end   

--- Next vertex function for <i>iter()</i> which returns tree nodes
-- in depth-first order. Use this as argument of <i>iter()</i>.
-- @param context context table for iterator
-- @param current the current node
-- @return next node
function depthfirst(context, current)
   if not current then
      context.stack = { context.start }
      context.visited = {}
   end
   local stack = context.stack
   local top = # context.stack -- pop from stack
   if top == 0 then return end
   current = context.stack[top]
   table.remove(stack)
   for _,v in current:successors() do table.insert(stack,v) end
   return current
end

--- Next function for <i>iter()</i> which returns tree nodes in 
-- breadth-first order. Use this as argument of <i>iter()</i>.
-- @param context context table for iterator
-- @param current the current node
-- @return next node
function breadthfirst(context, current)
   if not current then
      context.queue = { context.start }
      local queue = context.queue
      queue.head = 1
      queue.tail = 1
   end
   local queue = context.queue
   if queue.head - queue.tail < 0 then return end
   current = queue[queue.tail]
   queue[queue.tail] = nil
   queue.tail = queue.tail + 1
   for _,v in current:successors() do
      queue.head = queue.head+1
      context.queue[queue.head] = v
   end
   return current
end

--- Iterator which traverses the nodes of the tree using the specified
-- next function.
-- @param self tree node
-- @param nextfct the next function used to iterate the nodes
-- @return the for-loop iterator
function iter(self,nextfct)
   return nextfct or self.breadthfirst, { start = self }, nil
end

--- Traverses the nodes of the tree using a recursive depth-first.
-- @param self tree node
-- @param previsitor visitor called when node is entered 
-- @param postvisitor visitor called when node is exited
function traverse(self,previsitor,postvisitor)
   if not self:degree() == 0 then
      if previsitor then previsitor(self) end
      for _,v in self:successors() do 
	 v:foreach(previsitor,postvisitor)
      end
      if postvisitor then postvisitor(self) end
   end
end

--- Find an item within the tree using a recursive depth-first search. The 
-- default implementation uses a depth-first search.
-- @param self tree node
-- @param item the item to find
-- @return the sub-tree node which holds the item, or <i>nil</i> if not found
function find(self,item)
   if self:item() == item then return self end
   if self:degree() == 0 then return end
   for _,v in self:successors() do 
      node = v:find(item)
      if node then return node end
   end
end


----------------------------------------------------------------------------
