-- -*- lua -*-

project = select(1,...)

L = require ( project )
lib = require "scripts.lib"

function sign( name, stab )
   local fname = lib.find( name )   
   local fh = io.open(fname, "r")
   local buf = {}
   local hdr = 0
   while true do
      local l = fh:read("*line")
      if l == nil then break end   
      if hdr == 0 then
	 if l:find("_H%s*=%s*{") then hdr = 1 end
      elseif hdr == 1 then
	 for k,v in l:gmatch("(%w+)(%s*=%s*)") do
	    if stab[k] then
	       l = k..v..'"'..tostring(stab[k])..'",' 
	    end
	 end
	 if l:find("}") then hdr = 2 end
      end
--      for k in l:gmatch("module%s*%(%s*[\"\'](.*)[\"\']") do
--	 l = l:gsub(k:gsub("%.","%."),stab.FILE)
--      end
      table.insert(buf, l)
   end
   fh:close()
   local fh = io.open(fname, "w")
   for i=1, #buf do
      fh:write(buf[i].."\n")
   end
   fh:close()
   return hdr
end

print("> sign: "..project..".lua")
print("--------------------------------------------------------")
stab = {}
for k,v in pairs(L.signature) do
   if k == "DATE" then
      v = os.date("%d/%m/%Y %H:%M")
   end
   stab[k]= v
   print(k,v)
end
print("--------------------------------------------------------")
c = lib.getcomps(project)
for k,v in pairs(c) do
   io.write("signing "..k)
   stab.FILE = k
   ret = sign(k, stab)
   if ret > 0 then 
      print(" [ok]")
   else
      print(" [failed]")
   end
end

print("all done.")