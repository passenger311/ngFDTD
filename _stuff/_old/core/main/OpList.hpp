
#ifndef NEO_GUARD_OP_LIST_HPP
#define NEO_GUARD_OP_TIST_HPP

#include "Operator.hpp"
#include "EntityList.hpp"

#include <map>
#include <string>
#include <vector>
#include <iostream>

namespace neo {


  class OpList : public EntityList<Op>, public Operator {
    
  private:
    
  public:
    
    OpList(const std::string& name): Operator(name) {}
    
    void invoke() {
        for(int i=0; i<m_seq.count(); i++) { 
	m_seq.at(i)->invoke();
    }
    
};



}

#endif // NEO_GUARD_OP_LIST_HPP
