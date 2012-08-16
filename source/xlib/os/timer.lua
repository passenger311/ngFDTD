local _H = {
-------------------------------------------------------------------------------
PROJECT   = "neolib",
AUTHOR    = "J Hamm",
VERSION   = "0.2",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2",
FILE      = "neolib.os.timer",
-------------------------------------------------------------------------------
}

local L = require( _H.PROJECT )
local module = L.module
local clock = L.os.clock

-------------------------------------------------------------------------------

local _G, string, table, pairs, ipairs, io, tostring, type, require
   =  _G, string, table, pairs, ipairs, io, tostring, type, require
local _floor = math.floor

local
-------------------------------------------------------------------------------
--- <p><Prototype:</b> Stopwatch timer. 
-- </p>
--
module( "neolib.os.timer" )
------------------------------------------------------------------------------

this = proto.clone( proto.root, _M )

--- Create new timer.
-- @return timer
function new()
   return proto.clone(this, { last = 0, laps = {} } )
end

--- Reset timer by clearing lap times.
-- @self timer
function reset(self)
   self.laps = {}
   self.last = 0
end

--- Start timer.
-- @self timer
function start(self)
   self.last = clock.gettime()
end

--- Stop timer.
-- @self timer
-- @return total time passed since call of start().
function stop(self)
   local total = self.last
   for i=1, #self.laps do
      total = total - self.laps[i]
   end
   return total
end

--- Take lap time.
-- @self timer
-- @return time passed since last call of lap().
function lap(self)
   local now = clock.gettime()
   local laptime = now - self.last
   table_insert(self.laps, laptime )
   self.last = now
   return laptime
end

function is_running(self)
   return self.last ~= 0 
end

------------------------------------------------------------------------------

