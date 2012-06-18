local _H = {
-------------------------------------------------------------------------------
PROJECT   = "scape",
AUTHOR    = "J Hamm",
VERSION   = "0.3",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2",
FILE      = "scape.func.mexpr",
-------------------------------------------------------------------------------
}

local config = require "scape.config"
local math = require "scape.math"
local proto = require "scape.proto"

local _pairs, _ipairs, _type, _tostring, _assert, _print, _unpack, _select
   = pairs, ipairs, type, tostring, assert, print, unpack, select
local _random = math.random
local _insert = table.insert

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> Lisp style M-expressions. </p>
--
module("scape.func.mexpr")
-------------------------------------------------------------------------------

this = proto.clone( proto.root, _M )

function new( mexpr )
   local ret = proto.clone(this, { build(mexpr) })
end

function build(self)
   

end


proto.tag(this)
proto.scrub(this)
proto.fuse(this)

-------------------------------------------------------------------------------
