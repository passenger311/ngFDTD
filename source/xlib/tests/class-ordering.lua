local _H = {
-------------------------------------------------------------------------------
PROJECT   = "xlib",
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

-------------------------------------------------------------------------------

local _pcall, _print = pcall, print

-------------------------------------------------------------------------------
module( "xlib.tests.class-ordering" )
-------------------------------------------------------------------------------

this = unit.new(_M, { name = _H.FILE , repetition=200 } )

function ao(self)
   local O = class.def({id="O"})
   local A = class.def({id="A"}, O )
   result = { "A", "O" }
   for i,st in class.supers(A) do 
      unit.assert( st.id == result[i] ) 
   end
end

function abcnewo(self)
   local O = class.def({id="O"})
   local A = class.def({id="A"}, O )
   local B = class.def({id="B"}, O )
   local C = class.def({id="C"}, O )
   local D = class.def({id="D"}, O )
   local E = class.def({id="E"}, O )
   local F = class.def({id="F"}, O )
   local Z = class.def({id="Z"}, A, B, C, D, E, F )
   result = { "Z", "A", "B", "C", "D", "E", "F", "O" }
   for i,st in class.supers(Z) do 
      unit.assert( st.id == result[i] ) 
   end
end

function abc(self)
   local C = class.def({id="C"})
   local B = class.def({id="B"}, C ) 
   local A = class.def({id="A"}, C ) 
   local D = class.def({id="D"}, A, B ) 
   result = { "D", "A", "B", "C" }
   for i,st in class.supers(D) do 
      unit.assert( st.id == result[i] ) 
   end
end

function bcnewo(self)
   local O = class.def({id="O"})
   local F = class.def({id="F"}, O ) 
   local E = class.def({id="E"}, O ) 
   local D = class.def({id="D"}, O ) 
   local C = class.def({id="C"}, D ,F )
   local B = class.def({id="B"}, D ,E )
   local A = class.def({id="A"}, B ,C )
   result = { "A", "B","C","D","E","F","O" }
   for i,st in class.supers(A) do 
      unit.assert( st.id == result[i] ) 
   end
end

function becdfo(self)
   local O = class.def({id="O"})
   local F = class.def({id="F"}, O ) 
   local E = class.def({id="E"}, O ) 
   local D = class.def({id="D"}, O ) 
   local C = class.def({id="C"}, D ,F )
   local B = class.def({id="B"}, E ,D )
   local A = class.def({id="A"}, B ,C )
   result = { "A", "B","E","C","D","F","O" }
   for i,st in class.supers(A) do 
      unit.assert( st.id == result[i] ) 
   end
end

function xyyx(self)
   local O = class.def({id="O"})
   local X = class.def({id="X"}, O ) 
   local Y = class.def({id="Y"}, O ) 
   local A = class.def({id="A"}, X, Y ) 
   local B = class.def({id="B"}, Y ,X )
   unit.assert( not _pcall(class.def, {id="C"}, A ,B ) )
end

function fedcbao(self)
   local O = class.def({id="O"})
   local A = class.def({id="A"}, O )
   local B = class.def({id="B"}, A )
   local C = class.def({id="C"}, B )
   local D = class.def({id="D"}, C )
   local E = class.def({id="E"}, D )
   local F = class.def({id="F"}, E )
   local Z = class.def({id="Z"}, F,E,D,A )
   result = { "Z", "F", "E", "D", "C", "B", "A", "O" }
   for i,st in class.supers(Z) do 
      unit.assert( st.id == result[i] ) 
   end
end

------------------------------------------------------------------------------
