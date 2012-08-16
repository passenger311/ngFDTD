local __PROJECT__   = "xlib"
local __FILE__      = ".tests.struct.set"
local __AUTHOR__    = "J Hamm"
local __VERSION__   = "0.1"
local __DATE__      = "13/06/2011"
local __COPYRIGHT__ = "GPL V2"
local __MODULE__    = __PROJECT__..__FILE__
-------------------------------------------------------------------------------

local L = require( __PROJECT__ )
local unit = L.unit
local struct = L.struct
local set = struct.set

-------------------------------------------------------------------------------

local _pcall, _print = pcall, print

------------------------------------------------------------------------------
module( __MODULE__ )
------------------------------------------------------------------------------

this = unit.new(_M, { name = __MODULE__, repetition=5000 } )

function init()
   local set1 = set.new{1,2,3,4,5,6,7,8,9,10}
   for i = 1,10 do unit.assert( set1:contains(i) ) end
   unit.assert( not set1:contains(11) )
end

function merge() 
   local set1 = set.new{1,2,3,4,5}
   local set2 = set.new{6,7,8,9,10}
   set1:add(set2)
   for i = 1,10 do unit.assert( set1:contains(i) ) end
   unit.assert( not set1:contains(11) )
end

function substract()
   local set1 = set.new{1,2,3,4,5,6,7,8,9,10}
   local set2 = set.new{6,7,8,9,10}
   set1:del(set2)
   for i = 1,5 do unit.assert( set1:contains(i) ) end
   for i = 6,10 do unit.assert( not set1:contains(i) ) end
   unit.assert( not set1:contains(11) )
end

------------------------------------------------------------------------------
