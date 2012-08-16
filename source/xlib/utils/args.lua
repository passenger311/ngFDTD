local _H = {
-------------------------------------------------------------------------------
PROJECT   = "neolib",
AUTHOR    = "J Hamm",
VERSION   = "0.3",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2",
FILE      = "neolib.utils.options",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module

-------------------------------------------------------------------------------

local _G = _G
local _select, _setfenv, _getfenv = select, setfenv, getfenv
local _print = print
local osinfo = neolib.os.info

-------------------------------------------------------------------------------
--- <p><b>Module:</b> Process command line options. </p>
--
module( "neolib.utils.options" )
-------------------------------------------------------------------------------

-- args is the argument table
-- opts is a field that contains valid options in the format:
--   
--     { a = "n", b = "s",       mandatory options: number, string 
--       c = "l?",               optional option: logical
--       [1] = "s?",             optional argument 1: string
--       [2] = "l"               mandatory argument 2: logical
--     }
--
-- there are two types of arguments, "plain" arguments stored in 
-- a table and command line arguments stored in an array.   
-- 

--- Process plain table arguments. 
-- @param args table of function arguments
-- @param opts option table
-- @return table of values
function get( args, opts )
   local vals = {}
   for i=1, #args do
      local v, o = match(args[i], opts)
      vals[o] = v
   end
   if not ok(vals, opts) then 
      return usage(opts) 
   else
      return vals
   end
end

--- Process command line style arguments. 
-- @param cargs array of command line arguments
-- @param opts option table
-- @return table of values
function getcl( cargs, opts )
   -- convert into table arguments
   local args = {}
   for i=1, #cargs do
      local a = cargs[i]
      local opt, val = parsecl(a)
      if opt then
	 args[opt] = val
      else
	 _table_insert(args, a)
      end
   end
   return get( args, opts ) 
end


function parsecl(str)
   if osinfo.api == "POSIX" then
      if str:sub(1,2) == '--' then
	 str:sub(3):
      elseif str:sub(1,1) == '-' then

      end
   elseif osinfo.api == "WIN32" then


   else
      _error("unknown OS api")
   end
end

function match(arg, opts)


end


function ok(vals, opts)

end


function usage(opts)


end


------------------------------------------------------------------------------
