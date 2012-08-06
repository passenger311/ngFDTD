
#include "LuaClass.hpp"


class A : public neo::LuaClass {

public:
  A(const neo::LuaContext& context) : neo::LuaClass(context,"A") 
  {} 

};



int main() {

  neo::LuaContext context;

  A a(context);

}
