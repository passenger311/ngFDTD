local _H = {
-------------------------------------------------------------------------------
PROJECT   = "neolib",
AUTHOR    = "J Hamm",
VERSION   = "0.3",
DATE      = "13/06/2011",
COPYRIGHT = "GPL V2",
FILE      = "neolib.func.mexpr",
-------------------------------------------------------------------------------
}

local config = require "neolib.config"
local math = require "neolib.math"
local proto = require "neolib.proto"

local _pairs, _ipairs, _type, _tostring, _assert, _print, _unpack, _select
   = pairs, ipairs, type, tostring, assert, print, unpack, select
local _random = math.random
local _insert = table.insert

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> Lisp style M-expressions. </p>
--
module("neolib.func.mexpr")
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
