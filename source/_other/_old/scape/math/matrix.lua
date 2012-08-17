local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "31/08/2011 12:21",
COPYRIGHT = "GPL V2",
FILE      = "scape.math.matrix",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local proto = L.proto
local vector = L.vector

-------------------------------------------------------------------------------

local _pairs, _ipairs, _next, _tostring = pairs, ipairs, next, tostring
local _table_insert, _table_concat, _table_remove, _table_maxn 
   = table.insert, table.concat, table.remove, table.maxn
local _assert, _require = assert, require
local _math_max = math.max

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> a matrix of numerical values. </p>
-- </p>
module("scape.math.matrix")
-------------------------------------------------------------------------------

this = vector:_adopt( _M )

--- Create matrix and initialize with table.
-- @param items table of items
-- @param nc number of columes (optional)
-- @param nr number of rows (optional)
-- @return new matrix 
function new(items, nc, nr) 
   local tab = this:_adopt{} 
   if items then tab:fill(items) end 
   return tab
end

--- Pad nil values with zeroes making matrix dense.
-- @param self vector 
-- @return self
function pad(self)
   for i=1,self:rows() do
      for j=1,self:cols() do
	 if self[i][j] == nil then self[i][j] = 0 end
      end
   end
   return self
end

--- Purge all items.
-- @param self matrix 
-- @return self
function purge(self)
   for i = self:rows(),1  do 
      for j = self:cols(),1  do 
	 self[i][j] = nil
      end
   end
   return self
end

--- Create a clone of self.
-- @param self matrix 
-- @param object new object [{}]
-- @return clone of matrix.
function clone(self, object)
   local tab = {}
   for i = 1, #self do tab[i] = self[i] end
   return proto.clone(this, tab)
end

--- Fill with items.
-- @param self vector 
-- @param items table of items
-- @return self
function fill(self,items)
   local tovec = vector.tovector
   local maxl = 0
   for i,v in _pairs(items) do
      v = tovec(v)
      self[i] = v
      maxl = _math_max(maxl, _table_maxn(v))
   end
   return self:pad()
end

--- Count of specific item.
-- @param self reference
-- @param item item
-- @return count of item
function count(self,item)
   local c
   for i=1, #self do
      c = c + self[i]:count()
   end
   return c
end

-- Save content into table.
-- @param self matrix
-- @return a item table
function totable(self)
   local tab = {}
   for i=1,#self do
      tab[i] = self[i]:totable()
   end
   return tab
end

--- Arithmetic elementwise addition.
-- @param self matrix
-- @param other scalar or matrix
-- @return self
function add(self,other)
   if _type(other) == 'number' then 
      for i = 1, #self do
	 self[i]:add(other)
      end
   else
      if #self ~= #other then return nil end
      for i = 1, #self do
	 self[i]:add(other[i])
      end
   end
   return self
end

--- Arithmetic elementwise substraction.
-- @param self matrix
-- @param other scalar or matrix
-- @return self
function sub(self,other)
   if _type(other) == 'number' then 
      for i = 1, #self do
	 self[i]:sub(other)
      end
   else
      if #self ~= #other then return nil end
      for i = 1, #self do
	 self[i]:sub(other[i])
      end
   end
   return self
end

--- Arithmetic elementwise multiplication.
-- @param self matrix
-- @param other scalar or matrix
-- @return self
function mul(self,other)
   if _type(other) == 'number' then 
      for i = 1, #self do
	 self[i]:mul(other)
      end
   else
      if #self ~= #other then return nil end
      for i = 1, #self do
	 self[i]:mul(other[i])
      end
   end
   return self
end

--- Arithmetic elementwise division.
-- @param self matrix
-- @param other scalar or matrix
-- @return self
function div(self,other)
   if _type(other) == 'number' then 
      for i = 1, #self do
	 self[i]:div(other)
      end
   else
      if #self ~= #other then return nil end
      for i = 1, #self do
	 self[i]:div(other[i])
      end
   end
   return self
end


--- Apply function to elements of matrix.
-- @param self matrix
-- @param fun function
-- @return self
function apply(self, fun)
   for i = 1, #self do
      apply(self[i] , fun)
   end
end

--- Promote to matrix type.
-- @param self matrix
-- @return self
function tomatrix(self)
   return self
end

--- transpose matrix
-- @param self matrix
-- @return new matrix
function transpose( self )
    local res = {}
    for i = 1, #self[1] do
        res[i] = {}
        for j = 1, #self do
            res[i][j] = self[j][i]
        end
    end
    return new( res )
end

--- Matrix - Matrix multiplication.
-- @param a matrix
-- @param b matrix
-- @return vector
function mmul( a, b )
   if #a[1] ~= #b then return nil end
   local res = new()
   for i = 1, #a do
      res[i] = {}
      for j = 1, #b[1] do
	 res[i][j] = 0
	 for k = 1, #b do
	    res[i][j] = res[i][j] + a[i][k] * b[k][j]
	 end
      end
   end
   return res
end

function toscalar(self)
   if #self == 1 then
      if #self[1] == 1 then return res[1][1] end
   end
   return nil
end

function tovector(self)
   if #self == 1 then
      return vector.new( self[1] )
   end
   return nil
end

function reduce(self)
   return self:toscalar() or self:tovector() or self
end

--- Build a printable string from set.
-- @param self matrix
-- @return string 
function __tostring(self)
   local s = {}
   for i=1, #self do
      s[i] = "{".._table_concat(self[i],",").."}"
   end
   return "{".._table_concat(s,",").."}"
end

this:_seal()

-------------------------------------------------------------------------------
