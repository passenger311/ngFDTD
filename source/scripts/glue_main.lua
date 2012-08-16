
-- This all needs to be run with the proper luajit version!

lib = require("scripts.lib")

-- output directory for source files

local outdir = "main.src"
list_bytecode = {}

-- List of statically linked native modules

list_native = {
--     "luasocket",
--     "mime",
--     "unix"
}

-- Create list of lua modules to byte compile

c = lib.getcomps("neolib")
for k,v in pairs(c) do
   io.write("byte compiling "..k.."\t"..tostring(v).."\n")
   table.insert(list_bytecode,k)
end

-- Byte compile and preloader

lib.precompile(list_bytecode,"lua_bytecode",outdir)
lib.preloader(lib.merge(list_bytecode, list_native),"lua_preload",outdir)

