
-- lua initialization script

local shell_name = select(1,...)
local install_path = select(2,...)

print("install_path = '"..install_path.."'")
print("shell_name = '"..shell_name.."'")

SEP = _G.package.config:sub(1,1)

fh = io.open(install_path..SEP.."init.lua","w")
fh:write("install_path = '"..install_path.."'\n")
fh:write("shell_name = '"..shell_name.."'\n")
fh:write([[
	       print(install_path)
	 ]])
fh:close()

local glue = install_path..SEP.."bin"..SEP.."glue"
local srlua = install_path..SEP.."bin"..SEP.."srlua"
local init = install_path..SEP.."init.lua"
local outexe = install_path..SEP..shell_name
os.execute( glue.." "..srlua.." "..init.." "..outexe)

os.remove(init)

