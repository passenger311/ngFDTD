
#ifndef NEO_GUARD_GENERIC_FDTD_ENGINE_HPP
#define NEO_GUARD_GENERIC_FDTD_ENGINE_HPP

#include "Module.hpp"

namespace neo {

  class GenericFdtdEngine : public Module {

  public:
    
    Engine() : Module("") {
      addSequence("step");
      
      addSequence("stepE");
      addSequence("stepH");
    }
  

  };

}


#endif // NEO_GUARD_GENERIC_FDTD_ENGINE_HPP
