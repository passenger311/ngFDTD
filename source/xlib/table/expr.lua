-------------------------------------------------------------------------------
-- neolib.table.expr
--
-- @copyright $date$
-- @author    $author$
-- @release   $release$
-------------------------------------------------------------------------------
      
local proto = require "neolib.proto"

-------------------------------------------------------------------------------

local _type = type

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> array expressions using delayed evaluation.
-- </p>
--
module("neolib.table.expr")
-------------------------------------------------------------------------------

this = proto.clone( proto.root, _M )

list = [ "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q" ]

function new(tab)
   return proto.clone(this, { ["a"] = tab, [1] = "a", "a[i]" })
end


proto.fuse(this)
proto.tag(this)
proto.scrub(this)

-------------------------------------------------------------------------------
