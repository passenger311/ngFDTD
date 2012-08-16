local _H = {
-------------------------------------------------------------------------------
PROJECT   = "neolib",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "14/08/2012 16:01",
COPYRIGHT = "GPL V2",
FILE      = "neolib.os",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module

-------------------------------------------------------------------------------

local _G, string, table, pairs, ipairs, io, tostring, type, require
   =  _G, string, table, pairs, ipairs, io, tostring, type, require

-------------------------------------------------------------------------------
--- <p><b>Module:</b> os utility library. 
-- </p>
--
module( "neolib.os" )
------------------------------------------------------------------------------

module.extends("os")

module.imports{ 
   "info"
}

------------------------------------------------------------------------------

--- Execute a single command and capture both stdout and stderr in tables.
-- @param atab argument table
-- @return stdout and stderr as tables
function pexec( atab )
   local filter, verbose, ignore, wipe, cmdstr = 
      atab.filter, atab.verbose, atab.ignore, atab.wipe, atab[1]
   assert( type(cmdstr)=='string' and ( type(filter)=='string' or not filter))
   local out = {}
   local oh, err
   local outpipe, outfile = config.outpipe, config.outfile
   local errpipe, errfile = config.errpipe, config.errfile
   assert(errpipe and errfile, "error pipe or error file not defined")
   if wipe then cmdstr = cmdstr:gsub("%s+"," ") end
   if verbose then print(cmdstr) end
   cmdstr = fndec(cmdstr).." "..errpipe.." "..errfile
   os.remove(errfile)
   if config.popen then
      oh = io.popen(cmdstr)
   else
      os.execute(cmdstr.." "..outpipe.." "..outfile)
      oh = io.open(outfile,"r")
   end
   if oh then 
      while true do
	 local line = oh:read("*line")
	 if line == nil then break end
	 table.insert(out, line)
      end
      oh:close()
      os.remove(outfile)
   end      
   oh = io.open(errfile,"r")
   if oh then
      while true do
	 line = oh:read("*line")
	 if line == nil then break end
	 err = err or {}
	 table.insert(err, line) 
      end
      oh:close()
      os.remove(errfile)
   end
   return out, err
end



------------------------------------------------------------------------------

