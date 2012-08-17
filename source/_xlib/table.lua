local _H = {
-------------------------------------------------------------------------------
PROJECT   = "xlib",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "14/08/2012 16:01",
COPYRIGHT = "GPL V2",
FILE      = "xlib.table",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local utils = L.utils
      
-------------------------------------------------------------------------------

local _table, _pairs, _ipairs, _setmetatable, _getmetatable, _type
   =  table, pairs, ipairs, setmetatable, getmetatable, type

-------------------------------------------------------------------------------
--- <p><b>Module:</b> table utility library.
-- </p>
--
module( "xlib.table" )
-------------------------------------------------------------------------------

module.extends("table")

module.imports{ 
   --"eval",
   --"expr"
}

-------------------------------------------------------------------------------

copy = utils.copy

--- Protected copy. Existing entries are protected if the the key is 
-- is set in protection table.
-- @param source source table
-- @param dest destination table (optional)
-- @param prot protection table (optional)
-- @return dest
function pcopy(source, dest, prot)
   dest = dest or {}
   prot = prot or {}
   for k,v in _pairs(source) do
      if dest[k] == nil or not prot[k] then dest[k] = v end
   end
   return dest
end

--- Filter copy. The only entries which are copied from source to
-- destination are those with keys in the filter table. 
-- @param source source table
-- @param dest destination table (optional)
-- @param filter filter table (optional)
-- @return dest
function fcopy(source, dest, filter)
   dest = dest or {}
   filter = filter or {}
   for k,v in _pairs(source) do 
      if filter[k] then dest[k] = v end 
   end
   return dest
end


--- Invert table by swapping keys with values and vice versa. 
-- @param tab table
-- @return inverted table
function invert(tab)
   local ret = {}
   for k,v in _pairs(tab) do ret[v] = k end
   return ret
end

--- Create a set from array values. This function returns a table where
-- the array values are the keys and the values are all set to the given value
-- or <tt>true</tt>.
-- @param array array of keys
-- @param value value [<tt>true</tt>]
-- @return value set table
function valueset(array, value)
   local ret = {}
   value = value or true
   for i,v in _ipairs(array) do ret[v] = value end
   return ret
end

-- Clear a table by setting all values to <tt>nil</tt>. This allows to create
-- an empty table while the original storage address of the table is maintained.
-- @param tab table
-- @param ftab filter table
-- @return empty table
function wipe(tab, ftab)
   if ftab then
      for k,v in _pairs(tab) do if ftab[k] then tab[k] = nil end end      
   else
      for k,v in _pairs(tab) do tab[k] = nil end
   end
   return tab
end

--- Create a clone of table structure by performing a deep copy. Metatables 
-- are shallow copied. 
-- @param struct data structure or scalar
-- @return clone of data structure 
function clone(struct)
   if _type(struct) ~= "table" then return struct end
   local L = {} --> memoization table to avoid duplicates and cycles
   local function _deepcopy(struct)
      if _type(struct) ~= "table" then 
	 return struct 
      elseif L[struct] then 
	 return L[struct] 
      end
      local nt = _setmetatable({},_getmetatable(struct))
      L[struct] = nt
      for i, v in _pairs(struct) do nt[_deepcopy(i)] = _deepcopy(v) end
      return nt
   end
   return _deepcopy(struct)
end

--- Query table by string key. Instead of 
-- <i>tab["one"]["two"]["three"]</i> for example one may use 
-- <i>query(tab,"one.two.three")</i>.
-- @param tab table to query
-- @param strkey string key
-- @return the referenced entry or <tt>nil</ii> if it does not exist. 
function query(tab,strkey)
   for c in strkey:gmatch("[^%.]+") do
      if tab[c] then tab = tab[c] else return nil end
   end
   return tab
end

--- Retrieve key associated with table value.
-- @param tab table
-- @param value table value to search for
-- @return return key of value if found; <tt>nil</tt> otherwise 
function keyof(arr, value)
   for k,v in _pairs(tab) do 
      if value == v then return k end 
   end
   return nil
end

--- Retrieve index associated with array value.
-- @param tab array table
-- @param value array value to search for
-- @return return index of value if found; <tt>nil</tt> otherwise 
function indexof(tab, value)
   for i=1,#tab do 
      if tab[i] == value then return i end 
   end
   return nil
end

-------------------------------------------------------------------------------
