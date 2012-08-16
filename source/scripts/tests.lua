project = select(1,...)

print("--- tests "..project)
local unit = require (project..".tests")

if unit.invoke() then
   print("--- OK.")
else
   print("--- FAILED.")
end