
-- This script needs to be run with LuaJIT to create the proper byte code!!!

lib = require("scripts.lib")

------------------------------------
-- output directory for source files
------------------------------------

local outdir = "neon/src"
local unpackdir = "../build/unpack/"

--------------------------------------------
-- add native code modules to preloader list
--------------------------------------------

preloader_list = {

   -- startup script
   "neon.startup",

   -- luasocket (core and lua modules)
   "socket.core",
   "mime.core",
   "socket.unix",
   "socket",
   "mime",
   "ltn12",
   "socket.tp",
   "socket.ftp",
   "socket.http",
   "socket.url",
   "socket.smtp",

   -- luafilesystem (works)
   "lfs",

   nil
}

-------------------------------------
-- add lua modules to precompile list
-------------------------------------

precompile_list = { 

   -- startup script
   ["neon.startup"] = "neon/startup.lua",

   -- luasocket (lua files)
   ["socket"] = unpackdir.."luasocket/src/socket.lua",
   ["mime"] = unpackdir.."luasocket/src/mime.lua",
   ["ltn12"] = unpackdir.."luasocket/src/ltn12.lua",
   ["socket.tp"] = unpackdir.."luasocket/src/tp.lua",
   ["socket.ftp"] = unpackdir.."luasocket/src/ftp.lua",
   ["socket.http"] = unpackdir.."luasocket/src/http.lua",
   ["socket.url"] = unpackdir.."luasocket/src/url.lua",
   ["socket.smtp"] = unpackdir.."luasocket/src/smtp.lua",

   nil
}

-- autofetch libraries
lib.autofetch( "xlib", precompile_list, preloader_list)
lib.autofetch( "fdtd", precompile_list, preloader_list)

--------------------------------------------
-- Run byte compiler and create preload code
--------------------------------------------

lib.precompile(precompile_list,"lua_bytecode",outdir)
lib.preloader(preloader_list,"lua_preload",outdir)

