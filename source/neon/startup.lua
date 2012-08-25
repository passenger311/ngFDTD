-- startup code for neon

-- load libraries into global context
_G.xlib = require "xlib"
_G.fdtd = require "fdtd"

--[[
print("type help() ...") 

-- help function

function help(tab)
   if tab == nil then
      print("usage: help(module)")
      print("modules:")
      print("fdtd")
      print("xlib")
   else 
      if type(tab) == "table" then
	 print("modules:")
	 if type(tab._IMPORT) == "table" then
	    for k,v in ipairs(tab._IMPORT) do
	       print(v)
	    end
	 end
      end
   end
end
]]--