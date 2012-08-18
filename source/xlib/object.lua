local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.object",
VERSION   = "0.1",
DATE      = "17/08/2012 16:29",
COPYRIGHT = "(C) 2012",
-------------------------------------------------------------------------------
}

local xlib = require("xlib" )
local module = xlib.module

-------------------------------------------------------------------------------

local _error, _ipairs, _pairs, _getmetatable, _setmetatable, _rawget, _tostring
   = error, ipairs, pairs, getmetatable, setmetatable, rawget, tostring
local assert, print, type = assert, print, type
local _insert, _remove = table.insert, table.remove

-------------------------------------------------------------------------------
---<p><b>Module</b>: core object model. </p>
-- Allows to create and derive objects using <i>create</i>, <i>fuse</i>, 
-- <i>delegate</i> and <i>merge</i> functions. In combination with base 
-- linearizers and the various dispatch mechanisms these functions allow to 
-- implement a variety of object models. 
-- 
module( "xlib.object" )
-------------------------------------------------------------------------------

local ops = { "__add", "__sub", "__mod", "__div", "__mul", "__pow", "__concat",
	      "__tostring", "__len", "__eq", "__ne", "__lt", "__le", "__unm"}

function createmeta(tab, objects, self)
   for _,v in _ipairs(objects) do _insert(tab,v) end
   tab[1] = self
   return tab
end

function shallowcopy(tab, source)
   local f
   for k,v in _pairs(source) do 
      f = _rawget(tab, k)
      if f == nil then tab[k] = v end 
   end
   return tab
end

local function rawtostring(self) 
   local m = _getmetatable(self)
   local str = _tostring(_setmetatable(self,nil))
   _setmetatable(self,m)
   return str
end

local function _zero_iter(self, k)
   if not k then return 1, self end
   return 
end

local function m_abstract() _error("call to abstract method!") end 

local function m_dummy() end

-------------------------------------------------------------------------------

--- Return the abstract method. Abstract methods throw an error when invoked 
-- and are not allowed to remain exposed after fusion.
-- @param ... dummy arguments
-- @return abstract method
function abstractmethod() return m_abstract end

--- Return the dummy method. A dummy methods does nothing and is used when
-- a default do-nothing operation is required.
-- @param ... dummy arguments
-- @return dummy method
function dummymethod() return m_dummy end

--- Return an iterator over all ancestor objects.
-- @param self object
-- @return <i>ipairs()</i> style iterator
function ancestors(self)
   local meta = _getmetatable(self)
   if meta and meta ~= self then return _ipairs(meta) end
   return _zero_iter, self, nil
end

--- Check whether the argument is an object. 
-- @param self object
-- @return <i>true</i> or <i>false</i>
function isobject(self)
   if type(self) ~= 'table' then return false end
   local meta = _getmetatable(self)
   if not meta then return false end
   return meta[1] == self
end

--- Return the parent object of a delegate. Note, this function gives 
-- only predictable results if the argument is a delegate.
-- @param self delegate
-- @return parent object
function parent(self)
   local meta = _getmetatable(self)
   if not ( meta and meta.__index ) then return nil end
   if meta.__index == meta then return meta 
   elseif meta[1] then return meta[1] 
   else return nil
   end
end

--- Simple depth-first linearization of all ancestors.
-- @param ... list of objects
-- @return linearized table of ancestor objects
function dfbases(...)
   local map,list = {},{}
   for _,s in _ipairs({...}) do 
      for _,v in ancestors(s) do
	 if not map[v] then 
	    _insert(list,v)
	    map[v] = true 
	 end
      end
   end
   return list
end

local function _c3merge(seqs)
   local res = {}
   local cand
   while true do
      local nemptyseqs = {}
      for _,seq in _ipairs(seqs) do
	 if # seq > 0 then _insert(nemptyseqs,seq) end
      end
      if # nemptyseqs == 0 then return res end 
      local tail_map = {}
      for _,seq in _ipairs(seqs) do
	 for j = 2, # seq do tail_map[seq[j]] = true end
      end
      for _,seq in _ipairs(nemptyseqs) do 
	 cand = seq[1]
	 if tail_map[cand] then cand = nil else break end
      end
      assert(cand,"Failed to create consistent C3 MRO of ancestors!")
      _insert(res,cand)
      for _,seq in _ipairs(nemptyseqs) do
	 if seq[1] == cand then _remove(seq,1) end 
      end
   end
end

--- C3 linearization of all ancestors.
-- @param ... list of objects
-- @return linearized table of ancestor objects
function c3bases(...)
   local tab = {...}
   if #tab == 0 then return {} end
   local seqs = { {} }
   for _,b in _ipairs(tab) do 
      local seq = {}
      for _,a in ancestors(b) do
	 _insert(seq,a) 
      end
      _insert(seqs,seq)
   end
   return _c3merge( seqs )
end

--- Self-dispatch. 
-- @param self object
-- @param meta object metatable
-- @return object
function selfdispatch(self,meta) 
   self.__index = self 
   return _setmetatable(self,meta) 
end

--- Proxy-dispatch. Setup metatable index function which searches the array
-- elements of the metatable for dispatch.
-- @param self object table
-- @param meta metatable
-- @return object table
function proxydispatch(self, meta)
   meta.__index = function(t,k) 
		     for _,v in _ipairs(meta) do 
			local f = _rawget(v,k)
			if f ~= nil then return f end 
		     end
		     return nil
		  end
   for _,k in _ipairs(ops) do
      meta[k] = function(...) 
		   for _,v in _ipairs(meta) do 
		      local f = _rawget(v,k)
		      if f ~= nil then return f(...) end 
		   end
		   if k == "__tostring" then return rawtostring(...) end
		   _error(k.." not implemented!")
		end
   end
   return _setmetatable(self,meta)
end

--- Create a delegate to a parent object.
-- @param self parent object 
-- @param delegate <i>optional</i> table used for delegate
-- @return delegate
function delegate(self, delegate)
   if _rawget(self, "__index") == self then 
      return _setmetatable(delegate or {},self)
   else 
      return _setmetatable(delegate or {},_getmetatable(self))
   end
end

--- Create a new object. 
-- @param objects table of ancestor objects (optional)
-- @param dispatch dispatcher (optional, default: proxydispatch)
-- @return self
function create(self, objects, dispatch)
   if not objects then return selfdispatch(self,nil) end
   dispatch = dispatch or proxydispatch
   return dispatch(self, createmeta({ self }, objects, self))
end

--- Fuse ancestors into a single object.
-- @param self object table
-- @return self
function fuse(self)
   assert( type(self) == 'table' )
   if self.__index == self then return self end
   local objects = _getmetatable(self)
   assert( objects )
   local init = _rawget(self,"__init__")
   for i=2, #objects do shallowcopy(self, objects[i]) end
   self.__init__ = init
   local meta = {} 
   for i,v in _ipairs(objects) do _insert(meta,v) end
   return selfdispatch(self,meta)
end

--- Check whether an object has another object as ancestor.
-- @param self object 
-- @param object potential ancestor or parent object
-- @return <i>true</i> if other is an ancestor, <i>false</i> otherwise.
function implements(self, object) 
   for _,v in ancestors(self) do 
      if object == v then return true end 
   end
   return false
end

--- Merge the parent object into the delegate and return it as a new object.
-- @param self delegate
-- @return object
function merge(self)
   local parent = _getmetatable(self)
   local meta, cmeta, dispatch
   if parent.__index == parent then
      meta = _getmetatable(parent)
      if meta then cmeta = createmeta({ __call = meta.__call }, meta, self) end
      dispatch = selfdispatch
   else
      parent,meta = parent[1],parent  
      cmeta = createmeta({ self, __call = meta.__call }, meta, self)
      dispatch = proxydispatch
   end
   shallowcopy(self,parent)
   if self.__init__ == parent.__init__ then self.__init__ = nil end
   return dispatch(self, cmeta)
end

-------------------------------------------------------------------------------
