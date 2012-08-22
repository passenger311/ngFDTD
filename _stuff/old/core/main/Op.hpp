
#ifndef NEO_GUARD_OP_HPP
#define NEO_GUARD_OP_HPP

#include "Entity.hpp"

#include <map>
#include <string>
#include <vector>
#include <iostream>

namespace neo {


  class Op : public Entity {
    
  private:
    
  public:
    
    Op(const std::string& name) : Entity(name) {}
    
    virtual void invoke() {
      
    }

  };

  class 


  class FunOp : public Op {
    
  private:
    
    typedef void (*funptr_t)();
    
    funptr_t m_funptr; 

  public:
    
    FunOp(funptr_t funptr, const std::string& name) : 
      m_funptr(funptr), Op(name) {}
    
    void invoke() {
      
    }

  };

}

#endif // NEO_GUARD_OP_HPP
