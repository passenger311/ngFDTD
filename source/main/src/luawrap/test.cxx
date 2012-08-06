
#include "LuaClass.hpp"


class A : public Lua::LuaClass {

public:
  A(const Lua::LuaContext& context) : Lua::LuaClass(context,"A") 
  {} 

};



int main() {

  Lua::LuaContext context;

  A a(context);

}
