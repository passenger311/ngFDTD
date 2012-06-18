local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "31/08/2011 12:21",
COPYRIGHT = "GPL V2",
FILE      = "scape.utils",
-------------------------------------------------------------------------------
}


local module = require( _H.PROJECT..".module" )

-------------------------------------------------------------------------------

local G = _G
local _require, _pcall, _pairs, _assert, _type, _select, _setfenv, _loadfile
   = require, pcall, pairs, assert, type, select, setfenv, loadfile
local _getmetatable, _setmetatable = getmetatable, setmetatable
local _error, _getfenv, _print, _exit = error, getfenv, print, exit
local _package, _loaded = package, package.loaded
local _gsub, _gfind, _format = string.gsub, string.gfind, string.format
local _insert = table.insert
local _open, _stderr, _stdout = io.open, io.stderr, io.stdout

-------------------------------------------------------------------------------
--- <p><b>Module:</b> Generic (shared) utilities. </p>
--
module( "scape.utils" )
------------------------------------------------------------------------------

module.imports{ 
}

------------------------------------------------------------------------------

patterns = {
   FLOAT = '[%+%-%d]%d*%.?%d*[eE]?[%+%-]?%d*',
   INTEGER = '[+%-%d]%d*',
   IDEN = '[%a_][%w_]*',
   FILE = '[%a%.\\][:%][%w%._%-\\]*'
}

--- Shallow copy table.
-- @param source source table
-- @param dest destination table (optional)
-- @return dest
function copy(source, dest)
   dest = dest or {}
   for k,v in _pairs(source) do dest[k] = v end
   return dest
end

--- Select.
-- @param cond condition
-- @param val1 value 1 
-- @param val2 value 2
-- @return val1 if cond is not <tt>nil</tt> or <tt>false</tt>, val2 otherwise
function select( cond, val1, val2 )
   if cond then return val1 else return val2 end
end

--- Terminate gracefully.
-- @param code exit code (optional)
-- @param msg message to be printed (optional)
-- @param ... extra arguments for fprintf (optional)
-- @see scape.utils.fprintf
function quit(code,msg,...)
    if _type(code) ~= 'number' then
        msg = code
        code = -1
    end
    if msg then
       fprintf(_stderr,msg,...)
       _stderr:write('\n')
    end
    _exit(code)
end

--- Print an arbitrary number of arguments using a format.
-- @param fmt format string (see string.format)
-- @param ... arguments for format string
function printf(fmt,...)
    fprintf(_stdout,fmt,...)
end

--- Write an arbitrary number of arguments to handle using a format.
-- @param handle io handle
-- @param fmt format string (see string.format)
-- @param ... arguments for format string
function fprintf(handle,fmt,...)
    handle:write(_format(fmt,...))
end



------------------------------------------------------------------------------
