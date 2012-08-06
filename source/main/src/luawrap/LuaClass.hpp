
#ifndef INCLUDE_LUA_LUACLASS_HPP
#define INCLUDE_LUA_LUACLASS_HPP

#include "LuaContext.h"
#include <string>
#include <sstream>

namespace Lua {

  class LuaClass {
    
    const Lua::LuaContext& m_context;  // lua context
    const std::string m_mtname;        // meta table name
    std::string m_objname;             // object name


  private:

    void createNew() {
      // create new Lua object m_objname by invoking new() function of m_mtname

    }

  public:

    LuaClass(const Lua::LuaContext& context, const std::string& mtname) : 
      m_context(context), m_mtname(mtname) 
    {
      std::stringstream ss; 
      void* ptr = static_cast<void*>(this);
      ss << "ptr" << ptr << "\n";
      m_objname = ss.str();
      createNew();
    } 


  };





}

#endif // INCLUDE_LUA_LUACLASS_H
