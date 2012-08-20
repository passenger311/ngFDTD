
-- This all needs to be run with the proper luajit version!

lib = require("scripts.lib")

-- output directory for source files

local outdir = "neon/src"

-- add native code modules to preloader list

preloader_list = {

   -- luasocket (fixme: we also need the lua files)
--   "socket.core",
--   "mime.core",
--   "socket.unix",

   -- luafilesystem (works)
   "lfs"           
}

-- add lua modules to precompile list

precompile_list = { 
   ["neon.startup"] = "neon/startup.lua" 
}

lib.autofetch( "xlib", precompile_list, preloader_list)
lib.autofetch( "fdtd", precompile_list, preloader_list)

-- Byte compile and preloader

lib.precompile(precompile_list,"lua_bytecode",outdir)
lib.preloader(preloader_list,"lua_preload",outdir)

