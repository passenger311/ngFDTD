local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "31/08/2011 12:21",
COPYRIGHT = "GPL V2",
FILE      = "scape.io",
-------------------------------------------------------------------------------
}

local L = require(_H.PROJECT)
local module = L.module

------------------------------------------------------------------------------

local assert, loadfile, io, string = assert, loadfile, io, string
local _dump = string.dump
local _open = io.open

------------------------------------------------------------------------------
--- <p><b>Module:</b> io utility functions. This modes imports the lua io 
-- module.
-- </p>
--
module( "scape.io" )
------------------------------------------------------------------------------

module.extends("io")

module.imports{ 
   "fs"
}

------------------------------------------------------------------------------

--- Compile a lua file and write the byte-code to another file.
-- @param filein input lua source file
-- @param fileout output lua file containg byte-code
-- @return string containing byte-code
function compilefile(filein, fileout)
   local str = assert(loadfile(filein))
   if fileout then
      fh = assert(_open(fileout,"wb"))
      fh:write(_dump(str))
      fh:close()
   end
   return str
end


------------------------------------------------------------------------------
