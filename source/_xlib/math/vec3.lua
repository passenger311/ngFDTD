local _H = {
-------------------------------------------------------------------------------
PROJECT   = "xlib",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "14/08/2012 16:01",
COPYRIGHT = "GPL V2",
FILE      = "xlib.math.vec3",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local proto = L.proto

-------------------------------------------------------------------------------

local _pairs, _ipairs, _next, _tostring = pairs, ipairs, next, tostring
local _table_insert, _table_concat, _table_remove, _table_maxn 
   = table.insert, table.concat, table.remove, table.maxn
local _assert, _require, _type = assert, require, type
local _math_max, _print = math.max, print
local _rawget = rawget

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> 3-component vector. </p>
-- </p>
module("xlib.math.vec3")
-------------------------------------------------------------------------------

this = proto:_adopt( _M )

--- Create and initialize with table.
-- @param tab table with items
-- @return new vec3
function new(tab)
   local ret = this:_adopt( tab or { 0,0,0 } )
   return ret
end

--- Purge all items.
-- @param self vector 
-- @return self
function purge(self)
   for i=1,3 do 
      self[i]=nil
   end
   return self
end

--- Create a clone of self.
-- @param self vector 
-- @return clone of vector.
function clone(self)
   return proto.clone(this, { self[1], self[2], self[3] } )
end

--- Number of columns.
-- @param self vector 
-- @return number of items
function cols(self)
   return 3
end

size = cols

--- Is vector dense?
-- @param self vector
-- @return <tt>true</tt> if dense, <tt>false</tt> otherwise.
function isdense(self)
   return true
end


-- Save content into table.
-- @param self vector
-- @return a item table
function totable(self)
   return { self[1], self[2], self[3] }
end

--- Load from table.
-- @param self vector
-- @param tab item table
-- @return self
function fromtable(self,tab)
   self[1], self[2], self[3] = tab[1], tab[2], tab[3]
   return self
end

--- Arithmetic elementwise addition.
-- @param a vector
-- @param b vector
-- @return a
function add(a,b)
   a[1],a[2],a[3] = a[1] + b[1], a[2] + b[2], a[3] + b[3]
   return a
end

--- Arithmetic elementwise substraction.
-- @param a vector
-- @param b vector
-- @return a
function sub(a,b)
   a[1],a[2],a[3] = a[1] - b[1], a[2] - b[2], a[3] - b[3]
   return a
end

--- Scalar multiplication.
-- @param a vector
-- @param b scalar
-- @return a
function mul(a,b)
   a[1],a[2],a[3] = a[1] * b, a[2] * b, a[3] * b
   return a
end

--- Scalar division.
-- @param a vector
-- @param b scalar
-- @return a
function div(a,b)
   a[1],a[2],a[3] = a[1] / b, a[2] / b, a[3] / b
   return a
end

--- Vector addition.
-- @param a vector
-- @param b vector
-- @return vector
function __add(a, b)
   return new{ a[1] + b[1], a[2] + b[2], a[3] + b[3] }
end

--- Vector substraction.
-- @param a vector
-- @param b vector
-- @return vector
function __sub(a, b)
   return new{ a[1] - b[1], a[2] - b[2], a[3] - b[3] }
end

--- Scalar multiplication.
-- @param a scalar or vector
-- @param b scalar or vector
-- @return vector
function __mul(a,b)
   if _type(b) == 'number' then
      return new{ a[1] * b, a[2] * b, a[3] * b }
   else 
      return new{ a * b[1], a * b[2], a * b[3] }
   end
end

--- Divide vector by scalar.
-- @param a vector
-- @param b scalar
-- @return vector
function __div(a,b)
      return new{ a[1] / b, a[2] / b, a[3] / b }   
end

--- Unary minus.
-- @param a vector
-- @return vector
function __unm(a)
   return new{ - a[1], - a[2], - a[3] }
end

--- Vector-matrix multiplication.
-- @param a vector
-- @param b matrix
-- @return vector or scalar
function __mod(a,b)
   return new{ a[1]*b[1][1] + a[2]*b[2][1] + a[3]*b[3][1],
	       a[1]*b[1][2] + a[2]*b[2][2] + a[3]*b[3][2],
	       a[1]*b[1][3] + a[2]*b[2][3] + a[3]*b[3][3] }
end

--- Dot product.
-- @param a vector
-- @param b vector
-- @return scalar
function dot(a,b)
   return a[1]*b[1] + a[2]*b[2] + a[3]*b[3]
end

--- Apply function to elements of vector.
-- @param self vector
-- @param fun function
-- @return self
function apply(self, fun)
   self[1], self[2], self[3] = fun(self[1]),fun(self[2]),fun(self[3])
   return self
end

--- Promote vector or table to matrix type.
-- @param self vector
-- @return matrix
function tomatrix(self)
   local mat3 = _require "xlib.math.mat3"
   return mat3.new{ self } 
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
-- @return scalar
function toscalar(self)
   return nil
end

function reduce(self)
   return self
end

--- Build a printable string from set.
-- @param self vector
-- @return string 
function __tostring(self)
   return "{".._table_concat(self,",").."}"
end

this:_seal()


-------------------------------------------------------------------------------
