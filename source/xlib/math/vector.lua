local _H = {
-------------------------------------------------------------------------------
PROJECT   = "neolib",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "14/08/2012 16:01",
COPYRIGHT = "GPL V2",
FILE      = "neolib.math.vector",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local proto = L.proto
local math = L.math

-------------------------------------------------------------------------------

local _pairs, _ipairs, _next, _tostring = pairs, ipairs, next, tostring
local _table_insert, _table_concat, _table_remove, _table_maxn 
   = table.insert, table.concat, table.remove, table.maxn
local _assert, _require, _type = assert, require, type
local _math_max, _print = math.max, print
local _rawget = rawget

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> Sparse or dense vectors. </p>
-- A vector is an array that supports (via the prototype metatable) arithmetic
-- operations. Note: any arithmetic operation turns sparse vectors to 
-- dense vectors.
-- </p>
module("neolib.math.vector")
-------------------------------------------------------------------------------

this = proto:_adopt( _M )

function __index(self, idx)
   if _type(idx) == 'number' then return 0 end
   return this[idx]
end

--- Create vector and initialize with table.
-- @param tab table with items
-- @param nc number of colums (optional)
-- @return new vector 
function new(tab, nc)
   local ret = this:_adopt( tab or {} )
   ret.nc = nc or _table_maxn(tab)
   return ret
end

--- Pad nil values with zeroes making vector dense.
-- @param self vector 
-- @return self
function pad(self)
   for i= 1, cols(self) do
      if _rawget(self,i) == nil then self[i]=0 end
   end
   return self
end

--- Purge all items.
-- @param self vector 
-- @return self
function purge(self)
   for i=cols(self), 1, -1 do 
      self[i] = nil
   end
   return self
end

--- Create a clone of self.
-- @param self vector 
-- @return clone of vector.
function clone(self)
   local nc = cols(self)  
   local vec = new( tab, nc )
   if self:isdense() then
      for i= 1, nc do
	 vec[i] = self[i]
      end
   else
      for i,v in _ipairs(self) do
	 vec[i] = v
      end
   end
   return vec
end

--- Number of columns.
-- @param self vector 
-- @return number of items
function cols(self)
   return _math_max( _table_maxn(self), self.nc or 0 )
end

size = cols

--- Is vector dense?
-- @param self vector
-- @return <tt>true</tt> if dense, <tt>false</tt> otherwise.
function isdense(self)
   return #self == cols(self)
end

-- Save content into table.
-- @param self vector
-- @return a item table
function totable(self)
   local tab, nc = {}, cols(self)
   if self:isdense() then
      for i=1, nc do
	 tab[i] = self[i]
      end
   else
      for i,v in _pairs(self) do
	 tab[i] = v
      end
      tab.nc = nc
   end
   return tab
end

--- Load from table.
-- @param self vector
-- @param tab item table
-- @return self
function fromtable(self,tab)
   return new(tab, tab.nc)
end

--- Insitu elementwise addition.
-- @param self vector
-- @param other vector
-- @return self
function add(self,other)
   for i = 1, cols(self) do
      self[i] = self[i] + other[i]
   end
   return self
end

--- Insitu elementwise substraction.
-- @param self vector
-- @param other vector
-- @return self
function sub(self,other)
   for i = 1, cols(self) do
      self[i] = self[i] - other[i]
   end
   return self
end

--- Insitu scalar multiplication.
-- @param self vector
-- @param other scalar
-- @return self
function mul(self,other)
   for i = 1, cols(self) do
      self[i] = self[i] * other
   end
   return self
end

--- Scalar division.
-- @param self vector
-- @param other scalar
-- @return self
function div(self,other)
   for i = 1, cols(self) do
      self[i] = self[i] / other
   end
   return self
end

--- Vector addition.
-- @param a vector
-- @param b vector
-- @return vector
function __add(a, b)
   local tab, nc = {}, cols(a)
   for i = 1, nc do
      tab[i] = a[i] + b[i]
   end
   return new(tab, nc)
end

--- Vector substraction.
-- @param a vector
-- @param b vector
-- @return vector
function __sub(a, b)
   local tab, nc = {}, cols(a)
   for i = 1, nc do
      tab[i] = a[i] - b[i]
   end
   return new(tab, nc)
end

--- Scalar multiplication. Either a or b is a scalar.
-- @param a scalar or vector
-- @param b scalar or vector
-- @return vector
function __mul(a,b)
   if _type(a) == 'number' then a,b = b,a end
   local tab, nc = {}, cols(a)
   if a:isdense() then
      for i=1, nc do
	 tab[i] = a[i] * b
      end
   else
      for i,v in _ipairs(a) do
	 tab[i] = v * b
      end
   end
   return new(tab, nc)
end

--- Divide vector by scalar.
-- @param a vector
-- @param b scalar
-- @return vector
function __div(a,b)
   local tab, nc = {}, cols(a)
   if a:isdense() then
      for i=1, nc do
	 tab[i] = a[i] / b
      end
   else
      for i,v in _ipairs(a) do
	 tab[i] = v / b
      end
   end
   return new(tab, nc)
end

--- Unary minus.
-- @param a vector
-- @return vector
function __unm(a)
   local tab, nc = {}, cols(a)
   if a:isdense() then
      for i=1, nc do
	 tab[i] = - a[i]
      end
   else
      for i,v in _ipairs(a) do
	 tab[i] = - a[i]
      end
   end
   return new(tab, nc)
end

--- Vector-matrix multiplication.
-- @param a vector
-- @param b matrix
-- @return vector or scalar
function __mod(a,b)
   local nc1, nc2 = cols(a), cols(b)
   local tab = {}
   for i=1, nc2 do
      local s = 0
      for j=1, nc1 do
	 s = s + a[i]*b[j][i] 
      end
      tab[i] = s
   end
   return new( tab, nc2 ):reduce()    
end

--- Return transpose of vector represented as matrix.
-- @param a vector
-- @return matrix
function t(a)
   local tab, nc = {}, cols(a)
   for i=1, nc do
      tab[i] = { a[i] }
   end
   return math.matrix.new( tab, nc, 1 )    
end

--- Dot product.
-- @param self vector
-- @param other vector
-- @return scalar
function dot(a,b)
   local c = 0
   if a:isdense() then
      for i = 1, cols(a) do
	 c = c + a[i] * b[i]
      end
   else
      for i,v in _pairs(a) do
	 c = c + v * b[i]
      end
   end
   return c
end

--- Apply function to elements of vector.
-- @param self vector
-- @param fun function
-- @return self
function apply(self, fun)
   for i = 1, cols(a) do
      a[i] = fun(a[i])
   end
   return self
end

--- Promote vector or table to matrix type.
-- @param self vector
-- @return matrix
function tomatrix(self)
   return math.matrix.new{ self } 
end

--- Promote vector or table to vector type.
-- @param self vector
-- @return self
function tovector(self)
   if proto.type(self) == this then
      return self
   else
      return new(self)
   end
end

--- Promote vector or table to scalar type.
-- @param self vector
-- @return scalar or <tt>nil</tt>
function toscalar(self)
   if cols(self) == 1 then
      return self[1]
   end
   return nil
end

--- Promote vector to scalar or return self.
-- @param self vector
-- @return scalar or vector
function reduce(self)
   return self:toscalar() or self
end

--- Build a printable string from set.
-- @param self vector
-- @return string 
function __tostring(self)
   if self:isdense() then
      return "{".._table_concat(self,",").."}"
   else
      return "vector#".._tostring(cols(self))
   end
end

this:_seal()

-------------------------------------------------------------------------------
