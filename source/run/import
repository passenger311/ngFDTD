project = select(1,...)

L = require( project )

print(">> test initial import()")
t1 = os.clock()
L.import()
t2 = os.clock() - t1
print("-- in "..tostring(t2).." secs")
print(">> test second import()")
L.import() -- second
t3 = os.clock() - t2
print("-- in "..tostring(t3).." secs")
tab = L.module.loaded
print(">> imported modules:")
for k,v in pairs(tab) do 
   print(k,v)
end
--- random loads
n=1000
list = {}
for k,v in pairs(tab) do 
    table.insert(list, k)
end
print(">> test "..tostring(n).." random module loads")
t1 = os.clock()
for i=1,n do
   idx = math.random(1,#list)
   require(list[idx])
   _G.package.loaded[list[idx]]= nil
end
t2 = os.clock() - t1
print("-- in "..tostring(t2).." secs")
