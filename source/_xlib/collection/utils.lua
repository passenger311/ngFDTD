--[[---------------------------------------------------------------------------
$module      : xlib.collection.utils
$version     : 0.9 
$date        : 8/5/2008
$author      : j.hamm
$license     : x11 
$lua_ver     : 5.1
---------------------------------------------------------------------------]]--

local class = require "xlib.oop.class"

local ipair = ipairs

--- <p><b>Module:</b> 
-- some general utilitiy functions which operate on containers.
-- <p>
--
module("xlib.collection.utils")

-------------------------------------------------------------------------------

-- call visitor(i,v) function for all elements v of collection
function foreach(collection,visitor)
   local iter = collection.iter or ipairs
   for i,v in iter(collection) do visitor(i,v) end
end

-- set key = value for all elements in collection
function foreachassign(collection,key,value)
   local iter = collection.iter or ipairs
   for i,v in iter(collection) do v[key] = nil end
end


-------------------------------------------------------------------------------
