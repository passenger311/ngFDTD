
#ifndef NEO_GUARD_MODULE_HPP
#define NEO_GUARD_MODULE_HPP

#include "Operator.hpp"
#include "Entity.hpp"
#include "OpTable.hpp"

#include <map>
#include <string>
#include <vector>
#include <iostream>

namespace neo {

class Module : public Entity {

private:

  typedef void (*funptr_t)();

  OpList m_ops;
  
public:

  Module(const std::string name) : Entity(name), OpList(name) {}

  bool defOpList(const std::string name) {
    m_ops.add(name);
  }

  bool defineOp(funptr_t fun, const std::string name) {
    return m_ops.add(FunOperator(fun, name));
  }

  

};


}

#endif // NEO_GUARD_MODULE_HPP
