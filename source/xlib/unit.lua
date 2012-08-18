local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.unit",
VERSION   = "0.1",
DATE      = "18/08/2012 16:09",
COPYRIGHT = "(C) 2012 NEO·LIGHT Project",
-------------------------------------------------------------------------------
}

local xlib = require( "xlib" )
local module = xlib.module
local proto = xlib.proto

-------------------------------------------------------------------------------

local _G = _G
local _print, _tostring, _os, _assert, _table, _ipairs, _pairs, _io, _pcall
   =  print, tostring, os, assert, table, ipairs, pairs, io, pcall
local _type, _rawset = type, rawset
local _require = require

-------------------------------------------------------------------------------
--- <p><b>Prototype:</b> unit and performance testing. </p>
-- Offsprings of the unit prototype are considered unit tests. The functions
-- of a unit test form a collection of independent tests which are executed
-- in order of definition. 
--
module( "xlib.unit" )
-------------------------------------------------------------------------------

this = proto:adopt( _M )

--- Run a test. This method is invoked by <i>runall()</i> for each test. If run
-- seperately make sure to call <i>reset()</i> and <i>setup()</i> before the 
-- first and <i>teardown()</i> after invoking the last test.
-- @param self instance table
-- @return <tt>true</tt> if passed; <tt>false</tt> if failed
function run(self, name, count)
   local oh = _io.output()
   local err
   local ok, ret = true, true
   if not self.silent then 
      oh:write(self.prefix.."> Test ".._tostring(self.counted)..': "'..
	    name..'" (x'.._tostring(self.repetition or 1)..")\n")
   end
   local cl = _os.clock()
   for i = 1, self.repetition or 1 do
      ok,err = _pcall(self.tests[name], self)
      if not ok then break end
   end
   ret = ret and ok
   cl = _os.clock() - cl
   if not self.silent then 
      if ok then 
	 stat = "OK"
      else 
	 if err:find("xlib.test.unit") then
	    stat = "FAILED"
	 else
	    stat = "ERROR"
	    _print(err)
	 end
      end
      oh:write(self.prefix.."< Test ".._tostring(self.counted)..': "'..
	    name..'" '..stat.." (in ".._tostring(cl).."s)\n")
   end
   self.testclock[name] = cl
   self.testok[name] = ok
   self.counted = self.counted+1
   if ok then 
      self.passed = self.passed+1
   end
   assert(ret)
end

--- Reset test results and timings.
-- @param self instance table
function reset(self)
   self.testok = {}
   self.allok = nil
   self.testclock = {}
   self.allclock = nil 
   self.passed = 0
   self.counted = 0
end

--- Run all tests. This method invokes <i>reset()</i> and <i>setup()</i> first,
-- then runs all tests and finally calls the <i>teardown()</i> method. If 
-- <i>self.silent</i> is set it will run silently. 
-- @param self instance table
function runall(self)
   reset(self)
   self:setup()
   self.prefix = "[".._tostring(self.depth).."] "
   if not self.silent then
      _print(self.prefix..'Unit ["'..self.name..'"]')
   end
   local cl = _os.clock()
   for i, name in _ipairs(self.tests) do
      _pcall(run,self,name,count)
   end
   cl = _os.clock() - cl
   if not self.silent then 
      _print(self.prefix.."Passed ".._tostring(self.passed).." of "..
	 _tostring(self.counted).." (in ".._tostring(cl).."s)")
   end
   self.allok = (self.passed == self.counted)
   self.allclock = cl
   self:teardown()
end

--- Check whether a specific test succeeded. If no test is specified this
-- method will check whether all tests succeeded.  
-- @param self instance table
-- @param test name of test
-- @return <tt>true</tt> or <tt>false</tt>
function ok(self, test)
   if test then return self.testok[test] else return self.allok end
end

--- Check clock for a specific test. If no test is specified this
-- method will return the clock for all tests.  
-- @param self instance table
-- @param test name of test
-- @return <tt>true</tt> or <tt>false</tt>
function clock(self, test)
   if test then return self.clockok[test] else return self.allclock end
end

--- Setup test environment. The default method does nothing but can be 
-- overwritten by the subclass.
-- @param self instance table
function setup(self)
   -- no default actions
end

--- Teardown test environment. The default method does nothing but can be 
-- overwritten by the subclass.
-- @param self instance table
function teardown(self)
   -- no default actions
end

--- Assertion. Test will fail if assertion does not hold. Note, that Lua's
-- assert will also cause the test to to fail with an error instead. 
-- @param assertion assertion
function assert(assertion)
   _assert(assertion,"xlib.test.unit")
end

--- Fail test.
function fail()
   _assert(false,"xlib.test.unit")
end

--- Launch other test units from within the given unit. 
-- @param self instance table
-- @param tab table of other test classes
function launch(self, tab)
   _assert( _type(tab) == 'table' )
   local ok = true
   self.depth = self.depth+1
   for i,u in _ipairs(tab) do
      if _type(u) == 'string' then
	 u = _require( u )
      end
      local ret = u.invoke{ depth = self.depth }
      ok = ok and ret
   end
   self.depth = self.depth-1
   assert(ok)
end

--- Invoke unit. Setup and run all embedded tests. The instance table
--  may contain the following options:
-- <ul>
-- <li><tt>silent</tt>=<tt>true</tt> will suppress output</li>
-- <li><tt>repetition</tt>=<i>N</i> will cause each test to run <i>N</i> times
-- <li><tt>name</tt>=<i>Name</i> set test unit name to <i>Name</i>
-- </ul>
-- @param self instance
-- @return <tt>true</tt> if all tests passed; <tt>false</tt> otherwise
function invoke(self)
   self.name = self.name or "unknown"
   self.repetition = self.repetition or 1
   self.silent = self.silent or false
   self.depth = self.depth or 0
   self:runall()
   return self.allok
end

--- Create a new unit. The optional parameter table may contain the following 
-- options:
-- <ul>
-- <li><tt>silent</tt>=<tt>true</tt> will suppress output</li>
-- <li><tt>repetition</tt>=<i>N</i> will cause each test to run <i>N</i> times
-- <li><tt>name</tt>=<i>Name</i> set test unit name to <i>Name</i>
-- </ul> 
-- @param offspring offspring unit table
-- @param parms parameter table [{}]
-- @return unit table
function new(offspring, parms)
   this:adopt( offspring )
   offspring.tests = {}
   offspring.invoke = function(self)
		 self = self or {}
		 for k,v in _pairs(parms or {}) do self[k] = v end
		 return invoke(proto.adopt(offspring,self))
	      end
   return offspring
end

local ignore = { setup = true, teardown = true, invoke = true, __call = true,
	      __newindex = true }

__newindex = function(self, k, v)
		if _type(v) == 'function' and not ignore[k] then
		   _table.insert(self.tests, k)
		   self.tests[k] = v
		else
		   _rawset(self,k,v)
		end
	     end


this:seal()

-------------------------------------------------------------------------------
