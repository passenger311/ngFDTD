local _H = {
-------------------------------------------------------------------------------
PROJECT   = "neolib",
AUTHOR    = "J Hamm",
VERSION   = "0.2",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2",
FILE      = "neolib.table.serialize",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local proto = L.proto
local utils = L.utils

-------------------------------------------------------------------------------

local _G, _string, _table, _select, _type, _pairs, _ipairs, _assert, _require, _print
   =  _G, string, table, select, type, pairs, ipairs, assert, require, print

----------------------------------------------------------------------------
--- <p><b>Prototype:</b> Table serializer. </p>
-- Allows to serialize/deserialize tables from io-stream.
-- </p>
module( "neolib.table.serialize" )

----------------------------------------------------------------------------

this = proto.clone( proto.root, _M )

--- Create table serializer.
-- @param stream stream handler
-- @return new serializer
function new(stream)
   local ret = proto.clone(this, { stream = stream } )
   return ret
end


-- magic keys are used as internal references; do not use in strings!
local magicstring1 = "\222\233\244" -- some short bad-ass strings
local magicstring2 = "\244\222\233" 
local magicstring3 = "\233\244\222" 

---  Scan table for "simple" or "complex" structure. A "simple" table can 
-- can contain subtables and values of arbitrary type but no metatables, no 
-- function-type keys, no table-type keys.
-- @param tab the table to scan
-- @return a string "complex" or "simple" which indicates the type of the 
-- table and a lookup table for tab's internal metatables (if any). 
local function scantable(tab)
   local tabtype = "simple"
   local tmem = {}
   local mtab = {}
   mtab[tab] = getmetatable(tab)
   local function _scantable(tab)
      local kt,vt
      for k,v in pairs(tab) do 
	 kt,vt = type(k),type(v)
	 if kt == 'function' then
	    tabtype = "complex"
	 elseif kt == 'table' then 
	    mtab[k] = getmetatable(k)
	    tabtype = "complex"
	 end
	 if vt == 'table' then
	    mtab[v] = getmetatable(v)
	    if mtab[v] then tabtype = "complex" end
	    if tmem[v] then tabtype = "complex" else tmem[v] = true end
	    _scantable(v)
	 end
      end
   end
   _scantable(tab)
   return tabtype, mtab
end


-- Serialize a "complex" table into ostream.
-- @param tab the table to serialize
-- @param ostream output stream which supports the <i>write()</i> method
local function _serialize_complex(tab, ostream)
   local ftab,fmem,tmem, mtab = {},{},{},{}
   local fcount,tcount = 1,1
   local comma,ttab
   -- pack directory
   local function _serializeTable(tab,ps)
      local ttab
      local function _serializeFct(fct)
	 strref = fmem[fct]
	 if not strref then 
	    strref = magicstring1..tostring(fcount)
	    fmem[fct] = strref
	    ftab[strref] = fct
	    fcount = fcount + 1
	 end
	 return strref
      end
      local function _serializeTbl(tab)
	 strref = tmem[tab]
	 if not strref then 
	    strref = magicstring2..tostring(tcount)
	    tmem[tab] = strref
	    if not ttab then ttab = {} end
	    ttab[strref] = tab
	    tcount = tcount + 1
	 end
	 return strref
      end
      local vt,kt
      local comma = ""
      for k,v in pairs(tab) do	 
	 vt,kt = type(v),type(k)
	 ostream:write(comma.."[")
	 if kt == 'number' or kt == 'boolean' then 
	    ostream:write(tostring(k))  
	 elseif kt == 'string' then 
	    ostream:write(string.format("%q",k))
	 elseif kt == 'table' then
	    ostream:write(string.format("%q",_serializeTbl(k)))
	 elseif kt == 'function'  then
	    ostream:write(string.format("%q",_serializeFct(k)))
         else
	    error("bad key!") 
	 end
	 ostream:write("]=")
	 if  vt == 'number' or vt == 'boolean' then
	    ostream:write(tostring(v))
	 elseif vt == 'string' then
	    ostream:write(string.format("%q",tostring(v)))
	 elseif vt == 'table' then
	    ostream:write(string.format("%q",_serializeTbl(v)))
	 elseif vt == 'function'  then
	    ostream:write(string.format("%q",_serializeFct(v)))
	 else
	    error("bad value!") 
	 end
	 comma = ","
      end
      ostream:write(ps)
      local mt
      if ttab then
	 for k,v in pairs(ttab) do	 
	    ostream:write(comma.."["..string.format("%q",k).."]={")
	    _serializeTable(v,"}")
	 end
      end
   end
   -- serialize main table
   ostream:write("_S={")
   _serializeTable( { [magicstring2.."X"] = tab },"")
   -- serialize function table
   ostream:write("};_F={")
   comma = ""
   for k,v in pairs(ftab) do
      ostream:write(comma.."["..string.format("%q",k).."]=")
      ostream:write(string.format("%q",string.dump(v)))
      comma = ","
   end   
   ostream:write("}")
end

-- Serialize a "simple" table into ostream.
-- @param tab the table to serialize
-- @param ostream output stream which supports the <i>write()</i> method
local function _serialize_simple(tab, ostream)
   local ftab,fmem = {},{}
   local fcount = 1
   local comma
   -- pack directory
   local function _serializeTable(tab)
      local vt,kt
      local comma = ""
      for k,v in pairs(tab) do	 
	 vt,kt = type(v),type(k)
	 ostream:write(comma.."[")
	 if kt == 'number' or kt == 'boolean' then 
	    ostream:write(tostring(k))  
	 elseif kt == 'string' then 
	    ostream:write(string.format("%q",k))
	 else
	    error("bad key!") 
	 end
	 ostream:write("]=")
	 if  vt == 'number' or vt == 'boolean' then
	    ostream:write(tostring(v))
	 elseif vt == 'string' then
	    ostream:write(string.format("%q",tostring(v)))
	 elseif vt == 'table' then
	    ostream:write("{")
	    _serializeTable(v)
	    ostream:write("}")
	 elseif vt == 'function'  then
	    strref = fmem[v]
	    if not strref then 
	       strref = magicstring1..tostring(fcount)
	       fmem[v] = strref
	       ftab[strref] = v
	       fcount = fcount + 1
	    end
	    ostream:write(string.format("%q",strref))
	 else
	    error("bad value!") 
	 end
	 comma = ","
      end
   end
   -- serialize main table
   ostream:write("_S={")
   _serializeTable( { [magicstring2.."X"] = tab })
   -- serialize function table
   ostream:write("};_F={")
   comma = ""
   for k,v in pairs(ftab) do
      ostream:write(comma.."["..string.format("%q",k).."]=")
      ostream:write(string.format("%q",string.dump(v)))
      comma = ","
   end   
   ostream:write("}")
end


--- Deserialize string into a table. 
-- @param string the string which contains the serialized table
-- @return the table deserialized from the input string 
local function _deserialize(string)
   if type(string) ~= "string" then return nil end
   -- load and execute chunk
   local chunk = loadstring(string)
   local mtab = {}
   local fct
   if not chunk then return nil end
   local S,F = _G._S,_G._F
   chunk()
   local gtab,ftab = _G._S,_G._F
   _G._T,_G._F = T,F
   -- deserialize function table
   for k,v in pairs(ftab) do
      ftab[k] = loadstring(v) 
   end
   -- deserialize table (simple)
   local function _deserializeTable1(tab)
      for k,v in pairs(tab) do
	 -- values
	 if type(v) == 'table' then 
	    _deserializeTable1(v)
	 elseif ftab[v] then 
	    tab[k] = ftab[v]
	 end
      end
   end
   -- deserialize table
   local function _deserializeTable(tab)
      if mtab[tab] then return end
      mtab[tab] = true
      local fv,gv
      local rtab = {}
      for k,v in pairs(tab) do
	 -- keys
	 if ftab[k] then 
	    rtab[k] = ftab[k] 
	 elseif gtab[k] then
	    rtab[k] = gtab[k]
	 end
	 -- values
	 fv = ftab[v]
	 if fv then 
	    tab[k] = fv
	 else
	    gv = gtab[v]
	    if gv then
	       tab[k] = gv
	       _deserializeTable(gv)
	    end
	 end
      end
      -- change keys
      for k,v in pairs(rtab) do
	 tab[v] = tab[k] 
	 tab[k] = nil
	 _deserializeTable(v)
      end
   end
   local tab
   if type(gtab[magicstring2.."X"]) == 'table' then
      tab = gtab[magicstring2.."X"]
      _deserializeTable1(tab)
   else
      tab = gtab[gtab[magicstring2.."X"]]
      if not tab then return nil end
      _deserializeTable(tab)
   end
   ftab = nil
   gtab = nil
   if tab.meta then
      for k,v in pairs(tab.meta) do setmetatable(k,v) end
   end
   tab = tab.table

   -- this stuff down here should go into the ISerializer deserialize fct ...
   if tab.__pmeta then
      local metatab = require(tab.__pmeta[1])
      assert(metatab)
      for i=2,#tab.__pmeta do
	 metatab = metatab[tab.__pmeta[i]]
	 assert(metatab)
      end
      setmetatable(tab,metatab)
   end

   return tab
end

------------------------------------------------------------------------------

function serialize(self,tab)
   local stab = tab
   if tab.__pserialize then stab = tab:__pserialize() end
   local t,m = utils.scantable(stab)
   if t == "complex" then
      utils.serialize_complex({ table = stab, meta = m },sbuf)
   else
      utils.serialize_simple({ table = stab },sbuf)
   end
   if tab.__pdeserialize then tab:__pdeserialize() end
end

function deserialize(self,str)
   assert(type(str)=="string")
   local tab = _deserialize(str)
   if tab.__pdeserialize then tab:__pdeserialize() end
   return tab
end

proto.seal(_M)

----------------------------------------------------------------------------

