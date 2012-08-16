local _H = {
-------------------------------------------------------------------------------
PROJECT   = "neolib",
AUTHOR    = "J Hamm",
VERSION   = "0.1",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2",
FILE      = "log",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local proto = L.proto

-------------------------------------------------------------------------------

local _G, _string, _table, _pairs, _ipairs, _io, _tostring, _type, _require
   =  _G, string, table, pairs, ipairs, io, tostring, type, require
local _insert = table.insert
local _clock, _date, _time = os.clock, os.date, os.time

-------------------------------------------------------------------------------
--- <p><b>Module:</b> Event logger. 
-- </p>
--
module( "neolib.log" )
------------------------------------------------------------------------------

-- TODO need some proper handler to absract writing to tables / string /files
-- --> io/streamer ?

this = proto.clone( proto.root, _M )

--- Create new event logger.
-- @param handler input/output handler
-- @param cats table of event categories
-- @return new event logger
function new(  cats )
   cats = cats or { debug = -1, info = 0, warn = 1, error = 2, fatal = 3 }
   local tab = { file = {}, events = {}, categories = cats }
   for cat, pri in _pairs(cats) do 
      tab[cat] = function( self, info ) 
		  return register(self, info, pri)
	       end
   end
   return proto.clone(this,  tab )
end

--- Register event.
function register( self, info, pri )
   _insert(self.events, { _time(), info, pri })
   return self
end

--- Purge event table.
function purge(self)
   self.events = {}
   return self
end

--- 

proto.seal(this)

------------------------------------------------------------------------------

