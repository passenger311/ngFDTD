local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.utils",
VERSION   = "0.1",
DATE      = "17/08/2012 16:29",
COPYRIGHT = "(C) 2012",
-------------------------------------------------------------------------------
}


local module = require( "xlib.module" )

-------------------------------------------------------------------------------

local G = _G
local _exit, _pairs, _type = exit, pairs, type
local _stdout, _stderr, _format = io.stdout, io.stderr, string.format

-------------------------------------------------------------------------------
--- <p><b>Module:</b> Generic (shared) utilities. </p>
--
module( "xlib.utils" )
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
-- @see xlib.utils.fprintf
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
