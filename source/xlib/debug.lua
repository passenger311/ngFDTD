local _H = {
-------------------------------------------------------------------------------
PROJECT   = "neolib",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "14/08/2012 16:01",
COPYRIGHT = "GPL V2",
FILE      = "neolib.debug",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module

-------------------------------------------------------------------------------

local _G, _getmetatable, _setmetatable = _G, getmetatable, setmetatable
local _getinfo, _error, _rawset, _rawget = debug.getinfo, error, rawset, rawget
local _pairs, _write, _print, _type, _tostring =  
   pairs, io.write, print, type, tostring

-------------------------------------------------------------------------------
--- <p><b>Module:</b> debug extensions.
-- </p>
--
module( "neolib.debug" )
-------------------------------------------------------------------------------

module.extends("debug")
module.imports{ 

}

-------------------------------------------------------------------------------

--- Enable strict mode, disallowing access to/ use of undeclared globals.
-- Note: this adds a metatable to _G.
-- [Ref: S. Donovan, penlight library]
function strict()

   local handler,hooked

   local mt = _getmetatable(_G)
   if mt == nil then
      mt = {}
      _setmetatable(_G, mt)
   elseif mt.hook then 
      hooked = true 
   end

   mt.__declared = { _PROMPT = true }

   local function what ()
      local d = _getinfo(3, "S")
      return d and d.what or "C"
   end

   mt.__newindex = function (t, n, v)
		      if not mt.__declared[n] then
			 local w = what()
			 if w ~= "main" and w ~= "C" then
			    _error("assign to undeclared variable '"..n.."'", 2)
			 end
			 mt.__declared[n] = true
		      end
		      _rawset(t, n, v)
		   end
   
   handler = function(t,n)
		if not mt.__declared[n] and what() ~= "C" then
		   _error("variable '"..n.."' is not declared", 2)
		end
		return _rawget(t, n)
	     end
   
   if not hooked then
      mt.__index = handler -- directly set handler
   else
      mt.hook(handler) -- hook up handler
   end

end

--- Disable strict mode.
-- Note: this removes the metatable from _G.
function nostrict()
   local mt = _getmetatable(_G)
   if mt == nil then return end
   if mt.hook then
      mt.hook() -- unhook handler
   else
      _setmetatable(_G, nil) -- remove metatable     
   end
end


--- Dump content of variable/table.
-- [Ref: see Lua gems]
function dump(var, depth, ident)
   depth = depth or 1
   ident = ident or ""
   if _type(var) ~= 'table' then 
      if _type(var) == 'string' then
	 _write('"'..var..'"\n')
      else
	 _write(var.."\n")
      end
   else
      _write("{\n")
      ident = ident.."  "
      local first = true
      for k,v in _pairs(var) do
	 if not first then _write(ident..",\n") end
	 if _type(k) == 'number' then
	    _write(ident.."[".._tostring(k).."] = ") 
	    dump(v)	    
	 else
	    _write(ident.."['".._tostring(k).."'] = ") 
	    dump(v)
	 end
      end
      _write("}\n")
   end
end





-------------------------------------------------------------------------------
