local _H = {
-------------------------------------------------------------------------------
PROJECT   = "neolib",
FILE      = "tests.class-ordering",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2"
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local unit = L.unit
local class = L.class
local proto = L.proto

-------------------------------------------------------------------------------

local _pcall, _print = pcall, print

-------------------------------------------------------------------------------
module( "neolib.tests.class-proto" )
-------------------------------------------------------------------------------

this = unit.new(_M, { name = _H.FILE , repetition=200 } )

function test_1(self)
   local O = class.new({id="O"})
   local A = proto.clone(O, {} )
   for i,st in class.supers(A) do 
      unit.assert( st.id == result[i] ) 
   end
end

function abcnewo(self)
   local O = class.new({id="O"})
   local A = class.new({id="A"}, O )
   local B = class.new({id="B"}, O )
   local C = class.new({id="C"}, O )
   local D = class.new({id="D"}, O )
   local E = class.new({id="E"}, O )
   local F = class.new({id="F"}, O )
   local Z = class.new({id="Z"}, A, B, C, D, E, F )
   result = { "Z", "A", "B", "C", "D", "E", "F", "O" }
   for i,st in class.supers(Z) do 
      unit.assert( st.id == result[i] ) 
   end
end

function abc(self)
   local C = class.new({id="C"})
   local B = class.new({id="B"}, C ) 
   local A = class.new({id="A"}, C ) 
   local D = class.new({id="D"}, A, B ) 
   result = { "D", "A", "B", "C" }
   for i,st in class.supers(D) do 
      unit.assert( st.id == result[i] ) 
   end
end

function bcnewo(self)
   local O = class.new({id="O"})
   local F = class.new({id="F"}, O ) 
   local E = class.new({id="E"}, O ) 
   local D = class.new({id="D"}, O ) 
   local C = class.new({id="C"}, D ,F )
   local B = class.new({id="B"}, D ,E )
   local A = class.new({id="A"}, B ,C )
   result = { "A", "B","C","D","E","F","O" }
   for i,st in class.supers(A) do 
      unit.assert( st.id == result[i] ) 
   end
end

function becdfo(self)
   local O = class.new({id="O"})
   local F = class.new({id="F"}, O ) 
   local E = class.new({id="E"}, O ) 
   local D = class.new({id="D"}, O ) 
   local C = class.new({id="C"}, D ,F )
   local B = class.new({id="B"}, E ,D )
   local A = class.new({id="A"}, B ,C )
   result = { "A", "B","E","C","D","F","O" }
   for i,st in class.supers(A) do 
      unit.assert( st.id == result[i] ) 
   end
end

function xyyx(self)
   local O = class.new({id="O"})
   local X = class.new({id="X"}, O ) 
   local Y = class.new({id="Y"}, O ) 
   local A = class.new({id="A"}, X, Y ) 
   local B = class.new({id="B"}, Y ,X )
   unit.assert( not _pcall(class.new, {id="C"}, A ,B ) )
end

function fedcbao(self)
   local O = class.new({id="O"})
   local A = class.new({id="A"}, O )
   local B = class.new({id="B"}, A )
   local C = class.new({id="C"}, B )
   local D = class.new({id="D"}, C )
   local E = class.new({id="E"}, D )
   local F = class.new({id="F"}, E )
   local Z = class.new({id="Z"}, F,E,D,A )
   result = { "Z", "F", "E", "D", "C", "B", "A", "O" }
   for i,st in class.supers(Z) do 
      unit.assert( st.id == result[i] ) 
   end
end

------------------------------------------------------------------------------
