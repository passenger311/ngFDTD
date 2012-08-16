
#ifndef NEO_GUARD_ENTITY_HPP
#define NEO_GUARD_ENTITY_HPP

#include <string>
#include <iostream>

namespace neo {


 
  class Entity {
    
  private:
    
    std::string m_name;

  public:

    Entity() {
      m_name = "";
    }

    Entity(const std::string& name) {
      m_name = name;
    }

    const std::string& getName() const {
      return m_name;
    }

  };



} // namespace neo

#endif // NEO_GUARD_ENTITY_HPP
