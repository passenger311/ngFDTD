local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.3",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2",
FILE      = "scape.fun.op",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local config = L.config
local math = L.math
local proto = L.proto

-------------------------------------------------------------------------------

local _setmetatable = setmetatable

-------------------------------------------------------------------------------
--- <p><b>Module:</b> Operators. </p>
--
module("scape.fun.op")
-------------------------------------------------------------------------------

function eq(a,b)
   return a==b
end

function ne(a,b)
   return a~=b
end

function gt(a,b)
   return a>b
end

function ge(a,b)
   return a>=b
end

function lt(a,b)
   return a<b
end

function le(a,b)
   return a<=b
end

function add(a,b)
   return a+b
end

function sub(a,b)
   return a-b
end

function mul(a,b)
   return a*b
end

function div(a,b)
   return a/b
end

function mod(a,b)
   return a%b
end

function pow(a,b)
   return a^b
end

function concat(a,b)
   return a..b
end

_M["=="] = eq
_M["~="] = ne
_M[">"] = gt
_M[">="] = ge
_M["<"] = lt
_M["<="] = le
_M["+"] = add
_M["-"] = sub
_M["*"] = mul
_M["/"] = div
_M["%"] = mod
_M["^"] = pow
_M[".."] = concat



-------------------------------------------------------------------------------
