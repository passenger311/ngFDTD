-------------------------------------------------------------------------------
-- neolib.table.eval
--
-- @copyright $date$
-- @author    $author$
-- @release   $release$
-------------------------------------------------------------------------------
      
local proto = require "neolib.proto"

-------------------------------------------------------------------------------

local _type = type

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> table expression evaluation. This prototype implements
-- delayed (lazy) evaluation for table operations. 
-- </p>
--
module("neolib.table.eval")
-------------------------------------------------------------------------------

this = proto.clone( proto.root, _M )

function elwise_add(a,b)
   if _type(a) == 'number' then
      return function(i)
		return a + b(i)
	     end
   elseif _type(b) == 'number' then
      return function(i)
		return a(i) + b
	     end
   else
      return function(i)
		return a(i) + b(i)
	     end
   end
end


function elwise_sub(a,b)
   if _type(a) == 'number' then
      return function(i)
		return a - b(i)
	     end
   elseif _type(b) == 'number' then
      return function(i)
		return a(i) - b
	     end
   else
      return function(i)
		return a(i) - b(i)
	     end
   end
end

function elwise_mul(a,b)
   if _type(a) == 'number' then
      return function(i)
		return a * b(i)
	     end
   elseif _type(b) == 'number' then
      return function(i)
		return a(i) * b
	     end
   else
      return function(i)
		return a(i) * b(i)
	     end
   end
end

function elwise_div(a,b)
   if _type(a) == 'number' then
      return function(i)
		return a / b(i)
	     end
   elseif _type(b) == 'number' then
      return function(i)
		return a(i) / b
	     end
   else
      return function(i)
		return a(i) / b(i)
	     end
   end
end

function elwise_unm(a)
   return function(i)
	     return - a(i)
	  end
end

function elwise_eq(a,b)
   if _type(a) == 'number' then
      return function(i)
		return a == b(i)
	     end
   elseif _type(b) == 'number' then
      return function(i)
		return a(i) == b
	     end
   else
      return function(i)
		return a(i) == b(i)
	     end
   end
end

function elwise_ne(a,b)
   if _type(a) == 'number' then
      return function(i)
		return a ~= b(i)
	     end
   elseif _type(b) == 'number' then
      return function(i)
		return a(i) ~= b
	     end
   else
      return function(i)
		return a(i) ~= b(i)
	     end
   end
end

function elwise_gt(a,b)
   if _type(a) == 'number' then
      return function(i)
		return a > b(i)
	     end
   elseif _type(b) == 'number' then
      return function(i)
		return a(i) > b
	     end
   else
      return function(i)
		return a(i) > b(i)
	     end
   end
end

function elwise_ge(a,b)
   if _type(a) == 'number' then
      return function(i)
		return a >= b(i)
	     end
   elseif _type(b) == 'number' then
      return function(i)
		return a(i) >= b
	     end
   else
      return function(i)
		return a(i) >= b(i)
	     end
   end
end

function elwise_lt(a,b)
   if _type(a) == 'number' then
      return function(i)
		return a < b(i)
	     end
   elseif _type(b) == 'number' then
      return function(i)
		return a(i) < b
	     end
   else
      return function(i)
		return a(i) < b(i)
	     end
   end
end

function elwise_le(a,b)
   if _type(a) == 'number' then
      return function(i)
		return a <= b(i)
	     end
   elseif _type(b) == 'number' then
      return function(i)
		return a(i) <= b
	     end
   else
      return function(i)
		return a(i) <= b(i)
	     end
   end
end

__add = elwise_add
__sub = elwise_sub
__mul = elwise_mul
__div = elwise_div
__unm = elwise_unm
__eq = elwise_eq
__ne = elwise_ne
__gt = elwise_gt
__ge = elwise_ge
__lt = elwise_lt
__le = elwise_le

function __call(self, i)
   return self[i]
end



proto.fuse(this)
proto.tag(this)
proto.scrub(this)

-------------------------------------------------------------------------------
