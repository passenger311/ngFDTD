project = select(1,...)

lib = require( "scripts.lib" )

t1 = os.clock()

c = lib.getcomps( project )
tab = {}
for k in pairs(c) do
   local fn = lib.find(k)
   table.insert( tab, fn )
end

cmd = "luadoc --nofiles --doclet luadoc.doclet.html -d "..project..lib.DIRSEP.."doc/html "..table.concat(tab, " ")
print("> generating documentation")
print(cmd)
os.execute(cmd)

